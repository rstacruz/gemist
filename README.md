# Gemist
#### An extremely minimal solution to gem isolation

## Why?

Because the world doesn't need Bundler for gem management when Rubygems can do 
it already. Let me show you what I mean:

## Getting started

Make a file in your project called `Gemfile`.

    # Gemfile
    gem "sinatra"
    gem "ohm", "0.1.3"
   
    # These will only be for the development environment
    group :development do
      gem "json-pure", require: "json"
    end

In your project file, do this.
This `require`s the gems defined in the Gemfile.

    require 'gemist'
    Gemist.require

When you run your app, and some gems are not present, a message will show:

    $ ruby init.rb
    Some gems cannot be loaded. Try:

    gem install ohm -v 0.1.3
    gem install json-pure

## How does it work?

Gemist uses Rubygems to load specific gems. Did you know you can specify a 
gem version by doing `gem "sinatra", ">= 1.0"` in your Ruby project? Gemist 
is merely a light bridge that does that for you by reading your Gemfile.

For example, if your project has this Gemfile:

    gem "sinatra", "~> 1.2.0", require: "sinatra/base"
    gem "nokogiri", ">= 1.2"

Then you do:

    Gemist.require

All `Gemist.require` does in the background is:

    require 'rubygems'

    gem "sinatra", "~> 1.2.0"    # The method #gem is provided
    gem "nokogiri", ">= 1.2"     # by Rubygems.
    require "sinatra/base"
    require "nokogiri"

## Freezing versions

Bundler users: keep in mind that you will need to freeze gem versions in the 
`Gemfile` itself, as Gemist doesn't care about your `Gemfile.lock`.

This means that to ensure your app will work with future gem releases, you 
should add versions like so (using `~>` is highly recommended):

    # Gemfile
    gem "sinatra", "~> 1.1"

## More common usage

This `require`s the gems in a specific environment. If a group is not 
specified, Gemist assumes whatever is in `RACK_ENV`.

    require 'gemist'
    Gemist.require :development

## Vendoring gems

Gemist does NOT vendor gems for you. Rubygems helps you with that already!

First, don't specify your vendored gems in your Gemfile.

Second, freeze your gems like so:

    $ mkdir vendor
    $ cd vendor
    $ gem unpack sinatra

Then load them manually:

    # init.rb
    $:.unshift *Dir['./vendor/*/lib']
    require 'sinatra/base'

## Benchmarks

Informal benchmarks with a Gemfile of one of my projects on Ruby 1.9.2:

    Benchmark.measure { require 'bundler'; Bundler.require }  #=> 2.5s average
    Benchmark.measure { require 'gemist';  Gemist.require }   #=> 1.6s average

## Don't use this

This is merely a proof-of-concept. It works (very well), but:

1. The world has enough gem management tools, it doesn't need another.

2. Bundler is better (though it's more bloated and does more things).

## Not going to happen

Gemist will never have:

- **Dependency resolution.**  
If there are conflicts in your gems's requirements, just manually specify the 
gem version that will satisfy both.  Alternatively, stop using too many gems.

- **An installer (like 'bundle install').**  
Seriously, just install the gems yourself! Gemist even gives you the exact 
command to do it.

