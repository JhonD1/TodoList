require 'sinatra'
require 'sequel'

DB = Sequel.connect("sqlite://todo.db") #create in memory temporay Database if it doesn't exist else it will just connect to it

def make_table
  # create a table called Todo with id, task, and status  as columns
  DB.create_table? :todo do
    primary_key :id
    String :task
    String :status
  end
end

make_table

get '/' do
  if DB[:todo].first 
    @todo_list = DB[:todo] 
    erb :index
  else
    erb :no_task
  end
end

get '/add' do
  make_table

  erb :add
end

post '/add' do
  puts params
  
  @todo_list = DB[:todo]
  @todo_list.insert(task: params[:task], status: params[:task_status])

  redirect "/"
end

get '/delete/:id' do
  @todo_list = DB[:todo]
  @todo_list.where(id: params[:id]).delete

  redirect "/"
end

get '/delete' do
  DB.drop_table?(:todo)
  erb :no_task
end