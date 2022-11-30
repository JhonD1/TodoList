require 'sinatra'
require 'sequel'

DB = Sequel.connect("sqlite://todo.db") #create in memory temporay Database if it doesn't exist

# create a table called Todo with id, task, and status  as columns
DB.create_table? :todo do
  primary_key :id
  String :task
  String :status
end

get '/' do
  @todo_list = DB[:todo]
  erb :index
end

get '/add' do


  @todo_list = DB[:todo]
  @todo_list.insert(task: 'a121', status: 'not done')
  @todo_list.insert(task: 'grocery', status: 'not done')
  @todo_list.insert(task: 'todo-list in rails', status: 'not done')

  puts @todo_list
  erb :add
end
