module Crystal
  class Visitor
    [
      'module',
      'expressions',
      'int',
      'add',
      'sub',
      'mul',
      'div',
      'def',
      'ref',
      'var',
      'call',
      'lt',
      'let',
      'eq',
      'gt',
      'get',
      'if',
    ].each do |name|
      class_eval %Q(
        def visit_#{name}(node)
          true
        end

        def end_visit_#{name}(node)
        end
      )
    end
  end
end
