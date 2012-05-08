# Responsibilities:
# - Translate URL to helper object
# - Configure set of mappings used in aforementioned translation.

require 'rspec/expectations'
require 'yaml'

include RSpec::Matchers

class String
  def starts_with?(prefix)
    self[0..prefix.size-1].eql?(prefix)
  end
end

class PathToHelperMapper
  def initialize(args={})
    args.should be_kind_of(Hash)

    @session = nil
    if args[:session] then
      @session = args[:session]
      @session.should be_kind_of(Capybara::Session)
    end

    if args[:map_filename] then
      map_filename = args[:map_filename]
      map_filename.should be_kind_of(String)
      map_filename.size.should > 0
      mappings = File.open(map_filename, "r").read
    end

    if args[:map_file] then
      map_file = args[:map_file]
      map_file.should be_kind_of(File)
      mappings = map_file.read
    end

    if args[:mappings] then
      mappings = args[:mappings]
      mappings.should be_kind_of(String)
    end

    mappings.should_not be_nil

    @prefix_mapping = YAML.load(mappings)
    @memo = {}
  end

  def helper_for_path(p)
    p.should be_kind_of(String)

    class_name = helper_class_for_path(p)
    class_object = Kernel.const_get("Helpers").const_get(class_name)
    @memo[class_object] = class_object.new(:session => @session) if @memo[class_object].nil?
    return @memo[class_object]
  end

  private

  def helper_class_for_path(p)
    # Normalize URL to eliminate special cases.
    p = '/' if p.size == 0

    # Find all helpers that could potentially service the URL we're on.
    class_mapping = @prefix_mapping.select{|k,_| p.starts_with?(k)}

    # Choose the most specific handler (based on URL longest-prefix match).
    class_mapping = class_mapping.sort {|a,b| b.first.size <=> a.first.size}

    # Return the helper's class name.
    class_name = class_mapping.first[1]
    class_name.should be_kind_of(String)
    return class_name
  end
end
