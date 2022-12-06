require 'roda'
require 'sequel'

Roda.plugin :render

class App < Roda
  DB = Sequel.connect("sqlite://todo.db") #create in memory temporay Database if it doesn't exist else it will just connect to it

  def make_table
    # create a table called Todo with id, task, and status  as columns
    DB.create_table? :todo do
      primary_key :id
      String :task
      String :status
    end
  end

  route do |r|
    make_table
    r.root do
      if DB[:todo].first
        @todo_list = DB[:todo]
        render('index')
      else
        render('no_task')
      end
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