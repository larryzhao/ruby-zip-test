require 'zip/zip'
require 'zipruby'
require 'pry'

base_path = '/Users/larry/Braavos/ruby-zips/'
files_dir = File.join(base_path, 'files')
zips_dir = File.join(base_path, 'zips')

files = [] 

Dir.foreach(files_dir) do |item|
  next if item == '.' or item == '..'

  files << File.join(files_dir, item)
end

# system
GC::Profiler.enable
before_stats = ObjectSpace.count_objects
start = Time.now

zipfile = File.join(zips_dir, "zip-#{Time.now.to_i}.zip")

system("zip #{zipfile} #{files.join(' ')}")

puts "zip system: "
puts "[Total time] #{Time.now - start}"
after_stats = ObjectSpace.count_objects
puts "[GC Stats] #{before_stats[:FREE] - after_stats[:FREE]} new allocated"


# zipruby
GC::Profiler.enable
before_stats = ObjectSpace.count_objects
start = Time.now

zipfile = File.join(zips_dir, "zipruby-#{Time.now.to_i}.zip")

Zip::Archive.open(zipfile, Zip::CREATE) do |z|
  files.each do |f|
    z.add_file f.split('/').last, f
  end
end
puts "zipruby: "
puts "Total time: #{Time.now - start}"
after_stats = ObjectSpace.count_objects
puts "[GC Stats] #{before_stats[:FREE] - after_stats[:FREE]} new allocated objects."


# rubyzip
GC::Profiler.enable
before_stats = ObjectSpace.count_objects
start = Time.now

zipfile = File.join(zips_dir, "rubyzip-#{Time.now.to_i}.zip")

Zip::ZipOutputStream.open(zipfile) do |z|
  files.each do |file|
    z.put_next_entry(file.split('/').last)
    z.print IO.read(file)
  end
end

puts "Ruby Zip: "
puts "[Total time] #{Time.now - start}"
after_stats = ObjectSpace.count_objects
puts "[GC Stats] #{before_stats[:FREE] - after_stats[:FREE]} new allocated"

#puts "Zip Ruby: "
#puts "[Total time] #{Time.now - start}"
#after_stats = ObjectSpace.count_objects
#puts "[GC Stats] #{before_stats[:FREE] - after_stats[:FREE]} new allocated"


