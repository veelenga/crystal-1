require(File.expand_path("../../../lib/crystal",  __FILE__))

if ARGV.length != 1
  puts "Usage: compile FILE"
  exit
end

file = ARGV[0]
filename = file[0 .. -4]
lib_filename = File.expand_path("../../../ext/crystal.o",  __FILE__)

dump_exec = File.expand_path("../../../lib/crystal/dump.rb",  __FILE__)

`ruby #{dump_exec} #{file} 2> #{filename}.ll`
`opt -O3 -S #{filename}.ll > #{filename}.opt.ll`
`llvmc -O3 #{lib_filename} #{filename}.ll -o #{filename}`
