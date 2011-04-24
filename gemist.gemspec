Gem::Specification.new do |s|
  s.name = "gemist"
  s.version = "0.0.2"
  s.summary = %{An extremely minimal solution to gem isolation}
  s.description = %Q{Gemist leverages on purely Rubygems to require the correct gem versions in a project.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/gemist"
  s.files = ["lib/gemist/require.rb", "lib/gemist/setup.rb", "lib/gemist.rb", "README.md"]
end
