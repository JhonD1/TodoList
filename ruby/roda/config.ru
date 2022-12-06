require 'roda'
Roda.plugin :render

class App < Roda

  route do |r|
    r.root do
      "Hello. Welcome to Index"
    end

    r.on 'hello' do
      "prints hello?"

      r.get do 
        render('index')
      end
    end
  end
end

run App.freeze.app