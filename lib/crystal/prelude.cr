class Bool
  extern crystal_eq_bool Bool, Bool #=> Bool
  def ==(other)
    C.crystal_eq_bool self, other
  end
end

class Int
  extern crystal_add_int_int Int, Int #=> Int
  def +(other)
    C.crystal_add_int_int self, other
  end

  extern crystal_sub_int_int Int, Int #=> Int
  def -(other)
    C.crystal_sub_int_int self, other
  end

  extern crystal_mul_int_int Int, Int #=> Int
  def *(other)
    C.crystal_mul_int_int self, other
  end

  extern crystal_div_int_int Int, Int #=> Int
  def /(other)
    C.crystal_div_int_int self, other
  end

  extern crystal_lt_int_int Int, Int #=> Bool
  def <(other)
    C.crystal_lt_int_int self, other
  end

  extern crystal_let_int_int Int, Int #=> Bool
  def <=(other)
    C.crystal_let_int_int self, other
  end

  extern crystal_eq_int_int Int, Int #=> Bool
  def ==(other)
    C.crystal_eq_int_int self, other
  end

  extern crystal_gt_int_int Int, Int #=> Bool
  def >(other)
    C.crystal_gt_int_int self, other
  end

  extern crystal_get_int_int Int, Int #=> Bool
  def >=(other)
    C.crystal_get_int_int self, other
  end

  def +@
    self
  end

  def -@
    0 - self
  end
end

class Float
  extern crystal_add_float_float Float, Float #=> Float
  def +(other)
    C.crystal_add_float_float self, other
  end

  extern crystal_sub_float_float Float, Float #=> Float
  def -(other)
    C.crystal_sub_float_float self, other
  end

  extern crystal_mul_float_float Float, Float #=> Float
  def *(other)
    C.crystal_mul_float_float self, other
  end

  extern crystal_div_float_float Float, Float #=> Float
  def /(other)
    C.crystal_div_float_float self, other
  end

  extern crystal_lt_float_float Float, Float #=> Bool
  def <(other)
    C.crystal_lt_float_float self, other
  end

  extern crystal_let_float_float Float, Float #=> Bool
  def <=(other)
    C.crystal_let_float_float self, other
  end

  extern crystal_eq_float_float Float, Float #=> Bool
  def ==(other)
    C.crystal_eq_float_float self, other
  end

  extern crystal_gt_float_float Float, Float #=> Bool
  def >(other)
    C.crystal_gt_float_float self, other
  end

  extern crystal_get_float_float Float, Float #=> Bool
  def >=(other)
    C.crystal_get_float_float self, other
  end

  def +@
    self
  end

  def -@
    0.0 - self
  end
end

extern putb Bool #=> Nil
extern puti Int #=> Nil
extern putf Float #=> Nil
extern putchari Int #=> Nil
