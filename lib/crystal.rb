[
  'ast',
  'codegen',
  'compile_time',
  'eval',
  'lexer',
  'parser',
  'resolve',
  'token',
  'to_s',
  'yield',
  'visitor',
  'core_ext/false_class',
  'core_ext/fixnum',
  'core_ext/float',
  'core_ext/string',
  'core_ext/true_class',
].each do |filename|
  require(File.expand_path("../../lib/crystal/#{filename}",  __FILE__))
end
