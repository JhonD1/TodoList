require 'sinatra'
require 'sequel'

get '/' do
  erb :index
end

get '/add' do
  DB = Sequel.sqlite("todo.db") #create in memory temporay Database

  # drops table if it exists 
  DB.drop_table?(:todo)

  # create a table called Todo with id, task, and status  as columns
  DB.create_table :todo do
    primary_key :id
    String :task
    String :status
  end

  @todo_list = DB[:todo]
  @todo_list.insert(task: 'a121', status: 'not done')
  @todo_list.insert(task: 'grocery', status: 'not done')
  @todo_list.insert(task: 'todo-list in rails', status: 'not done')

  puts @todo_list
end
