require File.expand_path('../test_helper', __FILE__)

class RequireTest < Test::Unit::TestCase
  test "require: false" do
    Gem.expects(:activate).with('yard').returns(true)
    Kernel.expects(:require).with('yard').never

    use_gemfile 'require.gemfile'

    Gemist.require
  end
end
