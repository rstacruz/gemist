require File.expand_path('../test_helper', __FILE__)

class GemistTest < Test::Unit::TestCase
  setup do
    Gem.expects(:activate).with('sinatra', '>= 1.0', '<= 1.3').returns(true)
    Gem.expects(:activate).with('yard').returns(true)
    Gem.expects(:activate).with('test-unit', '~> 0.5').returns(true)
    Gem.expects(:activate).with('ffaker', '>= 1.0', '<= 1.3').returns(true)

    use_gemfile 'sample.gemfile'
  end

  test "sample - setup" do
    Gemist.setup
  end

  test "sample - require" do
    Kernel.expects(:require).with('sinatra').returns(true)
    Kernel.expects(:require).with('yard').returns(true)
    Kernel.expects(:require).with('test/unit').returns(true)
    Kernel.expects(:require).with('faker').returns(true)

    Gemist.require
  end
end
