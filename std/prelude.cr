class Object
end

class Class
  extern crystal_class_object_id Class : Long
  def object_id
    C.crystal_class_object_id self
  end

  def ==(other)
    self.object_id == other.object_id
  end

  def [](size)
    StaticArray(self).new size
  end
end

class Bool
  extern crystal_eq_bool Bool, Bool : Bool
  def ==(other)
    C.crystal_eq_bool self, other
  end

  extern crystal_and_bool_bool Bool, Bool : Bool
  def &(other)
    C.crystal_and_bool_bool self, other
  end

  extern crystal_or_bool_bool Bool, Bool : Bool
  def |(other)
    C.crystal_or_bool_bool self, other
  end

  extern crystal_xor_bool_bool Bool, Bool : Bool
  def ^(other)
    C.crystal_xor_bool_bool self, other
  end
end

class Number
  def +@
    self
  end

  def -@
    0 - self
  end

  def abs
    self >= 0 ? self : -self
  end

  def zero?
    self == 0
  end

  def step(limit, step)
    If step.class == Float
      num = self.to_f
    Else
      num = self
    End
    if step > 0
      while num <= limit
        yield num
        num += step
      end
    elsif step < 0
      while num >= limit
        yield num
        num += step
      end
    end
    self
  end
end

class Int < Number
  extern crystal_add_int_int Int, Int : Int
  def +(other)
    If other.class == Int
      C.crystal_add_int_int self, other
    Elsif other.class == Float
      self.to_f + other
    End
  end

  extern crystal_sub_int_int Int, Int : Int
  def -(other)
    If other.class == Int
      C.crystal_sub_int_int self, other
    Elsif other.class == Float
      self.to_f - other
    End
  end

  extern crystal_mul_int_int Int, Int : Int
  def *(other)
    If other.class == Int
      C.crystal_mul_int_int self, other
    Elsif other.class == Float
      self.to_f * other
    End
  end

  extern crystal_div_int_int Int, Int : Int
  def /(other)
    If other.class == Int
      C.crystal_div_int_int self, other
    Elsif other.class == Float
      self.to_f / other
    End
  end

  extern crystal_lt_int_int Int, Int : Bool
  def <(other)
    If other.class == Int
      C.crystal_lt_int_int self, other
    Elsif other.class == Float
      self.to_f < other
    End
  end

  extern crystal_let_int_int Int, Int : Bool
  def <=(other)
    If other.class == Int
      C.crystal_let_int_int self, other
    Elsif other.class == Float
      self.to_f <= other
    End
  end

  extern crystal_eq_int_int Int, Int : Bool
  def ==(other)
    If other.class == Int
      C.crystal_eq_int_int self, other
    Elsif other.class == Float
      self.to_f == other
    End
  end

  def >(other)
    If other.class == Int
      C.crystal_lt_int_int other, self
    Elsif other.class == Float
      self.to_f > other
    End
  end

  def >=(other)
    If other.class == Int
      C.crystal_let_int_int other, self
    Elsif other.class == Float
      self.to_f >= other
    End
  end

  extern crystal_shl_int_int Int, Int : Int
  def <<(other)
    C.crystal_shl_int_int self, other
  end

  extern crystal_shr_int_int Int, Int : Int
  def >>(other)
    C.crystal_shr_int_int self, other
  end

  extern crystal_mod_int_int Int, Int : Int
  def %(other)
    C.crystal_mod_int_int self, other
  end

  extern crystal_and_int_int Int, Int : Int
  def &(other)
    C.crystal_and_int_int self, other
  end

  extern crystal_or_int_int Int, Int : Int
  def |(other)
    C.crystal_or_int_int self, other
  end

  extern crystal_xor_int_int Int, Int : Int
  def ^(other)
    C.crystal_xor_int_int self, other
  end

  extern crystal_pow_int_int Int, Int : Float
  def **(other)
    If other.class == Int
      C.crystal_pow_int_int self, other
    Elsif other.class == Float
      self.to_f ** other
    End
  end

  extern crystal_bracket_int Int, Int : Int
  def [](bit)
    C.crystal_bracket_int self, bit
  end

  extern crystal_complement_int Int : Int
  def ~@
    C.crystal_complement_int self
  end

  def round
    self
  end

  def to_i
    self
  end

  def to_int
    self
  end

  def floor
    self
  end

  def ceil
    self
  end

  def truncate
    self
  end

  extern crystal_to_f_int Int : Float
  def to_f
    C.crystal_to_f_int self
  end

  def times
    if self > 0
      n = 0
      while n < self
        yield n
        n += 1
      end
    end
    self
  end

  def upto(n)
    if self <= n
      x = self
      while x <= n
        yield x
        x += 1
      end
    end
    self
  end

  def downto(n)
    if self >= n
      x = self
      while x >= n
        yield x
        x -= 1
      end
    end
    self
  end
end

class Char
  extern crystal_eq_char_char Char, Char : Bool
  def ==(other)
    C.crystal_eq_char_char self, other
  end
end

class Long
  extern crystal_eq_long_long Long, Long : Bool
  def ==(other)
    C.crystal_eq_long_long self, other
  end
end

class Float < Number
  extern crystal_add_float_float Float, Float : Float
  def +(other)
    C.crystal_add_float_float self, other.to_f
  end

  extern crystal_sub_float_float Float, Float : Float
  def -(other)
    C.crystal_sub_float_float self, other.to_f
  end

  extern crystal_mul_float_float Float, Float : Float
  def *(other)
    C.crystal_mul_float_float self, other.to_f
  end

  extern crystal_div_float_float Float, Float : Float
  def /(other)
    C.crystal_div_float_float self, other.to_f
  end

  extern crystal_lt_float_float Float, Float : Bool
  def <(other)
    C.crystal_lt_float_float self, other.to_f
  end

  extern crystal_let_float_float Float, Float : Bool
  def <=(other)
    C.crystal_let_float_float self, other.to_f
  end

  extern crystal_eq_float_float Float, Float : Bool
  def ==(other)
    C.crystal_eq_float_float self, other.to_f
  end

  def >(other)
    C.crystal_lt_float_float other.to_f, self
  end

  def >=(other)
    C.crystal_let_float_float other.to_f, self
  end

  extern crystal_pow_float_float Float, Float : Float
  def **(other)
    C.crystal_pow_float_float self, other.to_f
  end

  extern crystal_to_i_float Float : Int
  def to_i
    C.crystal_to_i_float self
  end

  def to_f
    self
  end
end

class Math
  extern crystal_math_sqrt Float : Float
  def self.sqrt(value)
    C.crystal_math_sqrt(value.to_f)
  end
end

extern puts_bool Bool : Nil
extern puts_int Int : Nil
extern puts_char Char : Nil
extern puts_float Float : Nil

def puts x
  If x.class == Bool
    C.puts_bool x
  Elsif x.class == Char
    C.puts_char x
  Elsif x.class == Int
    C.puts_int x
  Elsif x.class == Float
    C.puts_float x
  End
  x
end

extern print_bool Bool : Nil
extern print_int Int : Nil
extern print_char Char : Nil
extern print_float Float : Nil

def print x
  If x.class == Bool
    C.print_bool x
  Elsif x.class == Char
    C.print_char x
  Elsif x.class == Int
    C.print_int x
  Elsif x.class == Float
    C.print_float x
  End
end

def loop
  yield while true
end
