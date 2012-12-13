base_path = '/Users/larry/Braavos/ruby-zips/'
files_dir = File.join(base_path, 'files')
zips_dir = File.join(base_path, 'zips')

# create 2000 files.
count = 0

2000.times do
  filepath = File.join(files_dir, "#{count}.txt")
  file = File.open(filepath, 'w')
  file.write("#{count}" * 3)
  file.close
  count += 1
end
