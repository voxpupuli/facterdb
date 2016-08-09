require 'find'
require 'json'
require 'yaml'

dirs = Dir['[0-4].[0-9]']
Find.find( File.expand_path(File.dirname(__FILE__)) ) do |path|
  if FileTest.file?(path) && dirs.include?(File.basename(File.dirname(path)))
    if path =~ /\.UTF16LE/
      new_str = File.open(path,'rb:UTF-16LE')
                  .readlines
                  .join
                  .encode( Encoding.find('US-ASCII'), {invalid: :replace, undef: :replace, replace: ''})

      new_path = path.sub(/\.UTF16LE/,'')
      puts "== Converting '#{path}' to '#{new_path}'"
      File.open(new_path,'w'){|f| f.puts new_str}
      File.unlink path
    end
  end
end

Find.find( File.expand_path(File.dirname(__FILE__)) ) do |path|
  if FileTest.file?(path) && dirs.include?(File.basename(File.dirname(path)))
    if path =~ /.yaml$/
      str = YAML.load_file path
      new_path = path.sub(/\.yaml$/,'')
      puts "== Converting '#{path}' to '#{new_path}'"
      File.open(new_path,'w'){|f| f.puts str.to_json}
      File.unlink path
    end
  end
end
