require '../lib/gemist'
Gemist.require

class Main < Sinatra::Base
  get '/' do
    'yo!'
  end
end

Main.run!
