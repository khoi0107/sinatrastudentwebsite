require 'sinatra'
require 'slim'
require 'sass'
require './student'

get('/styles.css'){ scss :styles }

configure do     
	enable :sessions    
	set :username,"ktran"     
	set :password, "pwd" 
end
get '/' do
	redirect to('login') unless session[:admin]
  	slim :home
end

get '/about' do
  	@title = "All About This Website"
  	slim :about
end

get '/contact' do
  slim :contact
end

not_found do
  	slim :not_found
end

get '/login' do    
	if session[:admin]
		"You have already logined as Admin"
	else 
		slim :login
	end
end

post '/login' do     
	if params[:username] == settings.username && params[:password] == settings.password             
		session[:admin] = true       
		redirect to ('/students')     
	else       
		slim :login   
	end 
end

get '/logout' do
   	if session[:admin]
		session.clear   
   		redirect to ('/login') 
	else 
		"You have not logined yet!"
	end
end