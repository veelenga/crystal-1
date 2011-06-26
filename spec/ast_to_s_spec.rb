require(File.expand_path("../../lib/crystal",  __FILE__))

include Crystal

describe "ast nodes" do
  it "should to_s Int" do
    5.int.to_s.should eq('5')
  end

  [
    [Add, "+"],
    [Sub, "-"],
    [Mul, "*"],
    [Div, "/"],
    [LT, "<"],
    [LET, "<="],
    [EQ, "=="],
    [GT, ">"],
    [GET, ">="],
  ].each do |node, op|
    it "should to_s #{node}" do
      node.new(5.int, 6.int).to_s.should eq("5 #{op} 6")
    end
  end

  it "should to_s Def with no args" do
    Def.new("foo", [], [1.int]).to_s.should eq("def foo\n  1\nend")
  end

  it "should to_s Def with args" do
    Def.new("foo", ['var'.arg], [1.int]).to_s.should eq("def foo(var)\n  1\nend")
  end

  it "should to_s Def with many expressions" do
    Def.new("foo", [], [1.int, 2.int]).to_s.should eq("def foo\n  1\n  2\nend")
  end

  it "should to_s Ref" do
    "foo".ref.to_s.should eq("foo")
  end

  it "should to_s Call with no args" do
    Call.new("foo").to_s.should eq("foo()")
  end

  it "should to_s Call with args" do
    Call.new("foo", 1.int, 2.int).to_s.should eq("foo(1, 2)")
  end

  it "should to_s If" do
    If.new("foo".ref, 1.int).to_s.should eq("if foo\n  1\nend")
  end
end
