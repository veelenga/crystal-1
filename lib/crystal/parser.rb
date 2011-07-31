module Crystal
  class Parser < Lexer
    def self.parse(str)
      new(str).parse
    end

    def initialize(str)
      super
      next_token_skip_statement_end
    end

    def parse
      parse_expressions
    end

    def parse_expressions
      exps = []
      while @token.type != :EOF && !is_end_token
        exps << parse_expression
        skip_statement_end
      end
      Expressions.new exps
    end

    def parse_expression
      if @token.type == :IDENT
        case @token.value
        when :class
          return parse_class
        when :def
          return parse_def
        when :if
          return parse_if
        when :If
          return parse_static_if
        when :extern
          return parse_extern
        when :while
          return parse_while
        end
      end

      parse_primary_expression
    end

    def parse_class
      line_number = @token.line_number

      next_token_skip_space_or_newline
      check :IDENT

      name = @token.value
      next_token_skip_statement_end

      body = parse_expressions

      check_ident :end
      next_token_skip_statement_end

      class_def = ClassDef.new name, body
      class_def.line_number = line_number
      class_def
    end

    def parse_def
      next_token_skip_space_or_newline
      check :IDENT, :"=", :"<", :"<=", :"==", :">", :">=", :"+", :"-", :"*", :"/", :"+@", :"-@"

      name = @token.type == :IDENT ? @token.value : @token.type
      args = []

      next_token_skip_space

      case @token.type
      when :'('
        next_token_skip_space_or_newline
        while @token.type != :')'
          check_ident
          args << Var.new(@token.value)
          next_token_skip_space_or_newline
          if @token.type == :','
            next_token_skip_space_or_newline
          end
        end
        next_token_skip_statement_end
      when :IDENT
        while @token.type != :NEWLINE && @token.type != :";"
          check_ident
          args << Var.new(@token.value)
          next_token_skip_space
          if @token.type == :','
            next_token_skip_space_or_newline
          end
        end
        next_token_skip_statement_end
      else
        skip_statement_end
      end

      if @token.type == :IDENT && @token.value == :end
        body = nil
      else
        body = parse_expressions
        skip_statement_end
        check_ident :end
      end

      next_token_skip_statement_end
      Def.new name, args, body
    end

    def parse_if(check_end = true)
      line_number = @token.line_number

      next_token_skip_space_or_newline

      cond = parse_expression
      skip_statement_end

      a_then = parse_expressions
      skip_statement_end

      a_else = nil
      if @token.type == :IDENT
        case @token.value
        when :else
          next_token_skip_statement_end
          a_else = parse_expressions
        when :elsif
          a_else = parse_if false
        end
      end

      if check_end
        check_ident :end
        next_token_skip_statement_end
      end

      node = If.new cond, a_then, a_else
      node.line_number = line_number
      node
    end

    def parse_static_if(check_end = true)
      line_number = @token.line_number

      next_token_skip_space_or_newline

      cond = parse_expression
      skip_statement_end

      a_then = parse_expressions
      skip_statement_end

      a_else = nil
      if @token.type == :IDENT
        case @token.value
        when :Else
          next_token_skip_statement_end
          a_else = parse_expressions
        when :Elsif
          a_else = parse_static_if false
        end
      end

      if check_end
        check_ident :End
        next_token_skip_statement_end
      end

      node = StaticIf.new cond, a_then, a_else
      node.line_number = line_number
      node
    end

    def parse_while
      next_token_skip_space_or_newline

      cond = parse_expression
      skip_statement_end

      body = parse_expressions
      skip_statement_end

      check_ident :end
      next_token_skip_statement_end

      While.new cond, body
    end

    def parse_extern
      next_token_skip_space_or_newline
      check :IDENT
      name = @token.value
      next_token
      args_types = parse_args
      check :'#=>'
      next_token_skip_space
      return_type = parse_expression
      Prototype.new name, (args_types || []), return_type
    end

    def parse_primary_expression
      parse_question_colon
    end

    def parse_question_colon
      cond = parse_and
      if @token.type == :'?'
        next_token_skip_space_or_newline
        true_val = parse_expression
        check :':'
        next_token_skip_space_or_newline
        false_val = parse_expression
        cond = If.new(cond, true_val, false_val)
      end
      cond
    end

    def parse_and
      line_number = @token.line_number

      left = parse_or
      while true
        left.line_number = line_number
        case @token.type
        when :SPACE
          next_token
        when :"&&"
          method = @token.type
          next_token_skip_space_or_newline
          right = parse_or
          left = And.new left, right
        else
          return left
        end
      end
    end

    def parse_or
      line_number = @token.line_number

      left = parse_cmp
      while true
        left.line_number = line_number
        case @token.type
        when :SPACE
          next_token
        when :"||"
          method = @token.type
          next_token_skip_space_or_newline
          right = parse_cmp
          left = Or.new left, right
        else
          return left
        end
      end
    end

    def parse_cmp
      line_number = @token.line_number

      left = parse_add_or_sub
      while true
        left.line_number = line_number

        case @token.type
        when :SPACE
          next_token
        when :"<", :"<=", :"==", :">", :">="
          method = @token.type

          next_token_skip_space_or_newline
          right = parse_add_or_sub
          left = Call.new left, method, [right]
        else
          return left
        end
      end
    end

    def parse_add_or_sub
      line_number = @token.line_number

      left = parse_mul_or_div
      while true
        left.line_number = line_number
        case @token.type
        when :SPACE
          next_token
        when :"+", :"-"
          method = @token.type
          next_token_skip_space_or_newline
          right = parse_mul_or_div
          left = Call.new left, method, [right]
        when :INT
          case @token.value[0]
          when '+', '-'
            left = Call.new left, @token.value[0].to_sym, [Int.new(@token.value)]
            next_token_skip_space_or_newline
          else
            return left
          end
        else
          return left
        end
      end
    end

    def parse_mul_or_div
      line_number = @token.line_number

      left = parse_atomic_with_method
      while true
        left.line_number = line_number
        case @token.type
        when :SPACE
          next_token
        when :"*", :"/"
          method = @token.type
          next_token_skip_space_or_newline
          right = parse_atomic_with_method
          left = Call.new left, method, [right]
        else
          return left
        end
      end
    end

    def parse_atomic_with_method
      line_number = @token.line_number

      atomic = parse_atomic

      while true
        atomic.line_number = line_number

        case @token.type
        when :SPACE
          next_token
        when :'.'
          next_token_skip_space_or_newline
          check :IDENT, :"+", :"-", :"*", :"/", :"<", :"<=", :"==", :">", :">="
          name = @token.type == :IDENT ? @token.value : @token.type
          next_token

          args = parse_args
          block = parse_block
          if block
            atomic = Call.new atomic, name, args, block
          else
            atomic = args ? (Call.new atomic, name, args) : (Call.new atomic, name)
          end
        when :'='
          break unless atomic.is_a?(Ref)

          next_token_skip_space_or_newline

          value = parse_expression
          atomic = Assign.new(atomic, value)
        else
          break
        end
      end

      atomic
    end

    def parse_atomic
      case @token.type
      when :'('
        next_token_skip_space_or_newline
        exp = parse_expression
        check :')'
        next_token_skip_statement_end
        exp
      when :"+"
        next_token_skip_space_or_newline
        Call.new parse_expression, :"+@"
      when :"-"
        next_token_skip_space_or_newline
        Call.new parse_expression, :"-@"
      when :INT
        node_and_next_token Int.new(@token.value)
      when :FLOAT
        node_and_next_token Float.new(@token.value)
      when :CHAR
        node_and_next_token Char.new(@token.value)
      when :IDENT
        case @token.value
        when :nil
          node_and_next_token Nil.new
        when :false
          node_and_next_token Bool.new(false)
        when :true
          node_and_next_token Bool.new(true)
        when :yield
          parse_yield
        else
          parse_ref_or_call
        end
      else
        raise_error "unexpected token: #{@token.to_s}"
      end
    end

    def parse_ref_or_call
      name = @token.value
      next_token

      args = parse_args
      block = parse_block

      if block
        Call.new nil, name, args, block
      else
        args && args.length > 0 ? Call.new(nil, name, args) : Ref.new(name)
      end
    end

    def parse_block
      if @token.type == :IDENT && @token.value == :do
        parse_block2 { check_ident :end }
      elsif @token.type == :'{'
        parse_block2 { check :'}' }
      end
    end

    def parse_block2
      block_args = []
      block_body = nil

      next_token_skip_space
      if @token.type == :'|'
        next_token_skip_space_or_newline
        while @token.type != :'|'
          check :IDENT
          block_args << Var.new(@token.value)
          next_token_skip_space_or_newline
          if @token.type == :','
            next_token_skip_space_or_newline
          end
        end
        next_token_skip_statement_end
        block_body = parse_expressions
      else
        skip_statement_end
        block_body = parse_expressions
      end

      yield
      next_token_skip_statement_end

      Block.new(block_args, block_body)
    end

    def parse_yield
      next_token

      Yield.new parse_args
    end

    def parse_args
      case @token.type
      when :'{'
        nil
      when :"("
        args = []
        next_token_skip_space
        while @token.type != :")"
          args << parse_expression
          skip_space
          if @token.type == :","
            next_token_skip_space_or_newline
          end
        end
        next_token_skip_space
        args
      when :SPACE
        next_token
        case @token.type
        when :NEWLINE, :";", :"+", :"-", :"*", :"/", :"<", :"<=", :"==", :">", :">=", :'#=>', :"=", :'{', :'?', :':'
          nil
        else
          args = []
          while @token.type != :NEWLINE && @token.type != :";" && @token.type != :EOF && @token.type != :')' && @token.type != :'#=>' && !is_end_token
            args << parse_expression
            skip_space
            if @token.type == :","
              next_token_skip_space_or_newline
            end
          end
          next_token_skip_space unless @token.type == :')' || @token.type == :'#=>' || is_end_token
          args
        end
      else
        nil
      end
    end

    def node_and_next_token(node)
      next_token
      node
    end

    private

    def check(*token_types)
      raise_error "expecting token #{token_types}" unless token_types.any?{|type| @token.type == type}
    end

    def check_ident(value = nil)
      if value
        raise_error "expecting token: #{value}" unless @token.type == :IDENT && @token.value == value
      else
        raise_error "unexpected token: #{@token.to_s}" unless @token.type == :IDENT && @token.value.is_a?(String)
      end
    end

    def is_end_token
      return true if @token.type == :'}'
      return false unless @token.type == :IDENT

      case @token.value
      when :do, :end, :End, :else, :Else, :elsif, :Elsif
        true
      else
        false
      end
    end
  end
end
