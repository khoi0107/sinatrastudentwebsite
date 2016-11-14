require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/students.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :phone, Integer
  property :address, String
  property :enroll_on, Date
  
  def enroll_on=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end
DataMapper.finalize

get '/students' do
  @students = Student.all
  slim :students
end
get '/students/new' do
  halt(401, 'Not Authorized') unless session[:admin]
  @student = Student.new
  slim :new_student
end

get '/students/:id' do
  @student = Student.get(params[:id])
  slim :show_student
end

get '/students/:id/edit' do
  halt(401, 'Not Authorized') unless session[:admin]
  @student = Student.get(params[:id])
  slim :edit_student
end

post '/students' do  
  halt(401, 'Not Authorized') unless session[:admin]
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  halt(401, 'Not Authorized') unless session[:admin]
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  halt(401, 'Not Authorized') unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
