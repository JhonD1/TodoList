require 'roda'

class App < Roda
  route do |r|
    r.root do
      "Hello. Welcome to Index"
    end

    r.on 'hello' do
      "prints hello?"

      r.get do 
        "hello there welcome to the get in Hello route"
      end
    end
  end
end

run App.freeze.app