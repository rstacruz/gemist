require 'ostruct'

# Gem environment manager.
module Gemist
  # Loads the gems via +require+.
  def self.require(env=ENV['RACK_ENV'])
    load_rubygems
    setup env
    gemfile.gems_for(env).each { |g| g.require! }
  end

  # Loads the gems for a given environment.
  def self.setup(env=ENV['RACK_ENV'])
    @fail = Array.new

    gemfile.gems_for(env).each do |g|
      g.load! or @fail << g
    end

    if @fail.any?
      list = @fail.map { |g| g.to_command }.join(' ')
      $stderr << "Some gems failed to load.\n"
      $stderr << "Try: gem install #{list}\n"
      exit
    end
  end

  # Returns the Gemfile for the current project.
  def self.gemfile
    @@gemfile ||= Gemfile.load
  end

private
  # Loads rubygems. Skips if it's not needed (like in Ruby 1.9)
  def self.load_rubygems
    Kernel.require 'rubygems'  unless Object.const_defined?(:Gem)
  end
end

# A definition of a project Gemfile manifest.
class Gemist::Gemfile
  # Returns the path of the project's Gemfile manifest, or +nil+ if
  # not available.
  def self.path
    Dir["./{Gemfile,Isolate}"].first
  end

  # Checks if the project has a Gemfile manifest.
  def self.exists?
    !!path
  end

  # Returns a Gemfile instance made from the project's manifest.
  def self.load
    new File.read(path)  if exists?
  end

  def initialize(contents)
    instance_eval contents
  end

  # The list of gems the Gemfile. Returns an array of Gem instances.
  def gems()
    @gems ||= Array.new
  end

  # Returns a list of Gem instances for the given environment.
  def gems_for(env)
    gems.select { |g| g.group == nil || g.group.include?(env.to_s.to_sym) }
  end

private
  # (DSL) Adds a gem.
  #
  # == Example
  #
  #   # Gemfile
  #   gem "sinatra"
  #   gem "sinatra", "1.1"
  #   gem "sinatra", "1.1", :require => "sinatra/base"
  #
  def gem(name, ver=nil, options={})
    ver, options = nil, ver  if ver.is_a?(Hash)

    options[:name]    ||= name
    options[:version] ||= ver
    options[:group]   ||= @group

    self.gems << Gemist::Gem.new(options)
  end

  # (DSL) Defines a group.
  #
  # == Example
  #
  #   # Gemfile
  #   group :test do
  #     gem "capybara"
  #   end
  #
  def group(*names, &blk)
    @group = names.map { |s| s.to_sym }
    yield
    @group = nil
  end
end

# A Gem in the gemfile.
class Gemist::Gem
  attr_accessor :name
  attr_accessor :version
  attr_accessor :require
  attr_accessor :group

  def initialize(options)
    self.name    ||= options[:name]
    self.version ||= options[:version]
    self.group   ||= options[:group]
    self.require ||= options[:require] || self.name
  end

  # Activates the gem; returns +false+ if it's not available.
  def load!
    Kernel.send :gem, name, version
  rescue ::Gem::LoadError
    false
  end

  # Loads the gem via +require+. Make sure you load! it first.
  def require!
    Kernel::require require
  end

  # Returns the +gem install+ paramaters needed to install the gem.
  def to_command
    [name, ("-v \"#{version}\""  if version)].compact.join ' '
  end
end
