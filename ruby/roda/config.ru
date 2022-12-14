require 'roda'
require 'sequel'

Roda.plugin :render

class App < Roda
  DB = Sequel.connect("sqlite://todo.db") #create in memory temporay Database if it doesn't exist else it will just connect to it

  def make_table
    # create a table called Todo with id, task, and status as columns
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

    r.on 'add' do
      r.get do 
        render('add')
      end

      r.post do
        @todo_list = DB[:todo]
        @todo_list.insert(task: r.params['task'], status: r.params['task_status'])

        r.redirect '/'
      end
    end

    r.on 'edit' do
      r.is Integer do |id|
        todo_list = DB[:todo]
        @task = todo_list.where(id: id)

        r.get do
          render('edit')
        end

        r.post do 
          @task.update(task: r.params['task'], status: r.params['status'])

          r.redirect '/'
        end
      end
    end

    r.on 'delete' do
      r.is Integer do |id|
        r.get do
          @todo_list = DB[:todo]
          @todo_list.where(id: id).delete
          
          r.redirect '/'
        end
      end

      r.is do 
        r.get do
          DB.drop_table?(:todo)
          render('no_task')
        end
      end
    end

  end
end

run App.freeze.app