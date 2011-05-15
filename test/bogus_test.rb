require File.expand_path('../test_helper', __FILE__)

class BogusTest < Test::Unit::TestCase
  test "bogus - print requirements" do
    Gemist.expects(:exit).returns(true)

    use_gemfile 'bogus.gemfile'

    Gemist.setup
    assert err.include?("gem install xyzzyabc\n")
    assert err.include?("gem install aoeuidhtns\n")
    assert err.include?("gem install pyfgcrl -v \">= 3.0\"\n")
    assert err.include?("gem install qjkxbmwvz -v \"<= 4.0\" -v \">= 3.0\"\n")
  end
end
