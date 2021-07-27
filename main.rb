require 'sinatra'
require 'digest/sha1'

enable :sessions

set :public_folder, __dir__ + '/html'

get '/' do
  @r_string = ""
  if(session[:logged_in]) # I check if the user is already autenticated
    redirect '/dashboard' #if it is I redirect it to the dashboard
  elsif (!session[:random_string])  # Othewise I check if I already created its personal key, if I did not I create it
    length = rand(80) + 1   #generate the length of a random string
    @r_string = (0...length).map{((rand(2)==1?65:97) + rand(25)).chr}.join   #generates the random string using somethig that is similar to streams
    session[:random_string] = @r_string  # saves the string to the session
  else
    @r_string = session[:random_string]
  end

  erb :index
end

get '/login' do
  redirect '/'
end

post '/login' do 
  if(session[:logged_in])
    redirect '/dashboard'
  end

  @r_string = session[:random_string]  #I recuperate the random string
  if(!@r_string)  # if is not set I redirect to the login page
    redirect '/'
  end

  password = "password" # the password

  server_hash = Digest::SHA1.hexdigest(password + @r_string)  #computes the correct hash
  client_hash = params[:hash] #gets the client hash

  if(server_hash == client_hash)  #if they match the user is authenticated
    session[:logged_in] = true
    redirect '/dashboard'
  else  #otherwise it is redirected to the error page
    redirect '/login-error'
  end

end

get '/login-error' do
  @file = File.read("html/error.html")  #reads the file
  erb("<%= @file %>") #prints the file
end

get '/dashboard' do
  if(!session[:logged_in])  #check if the user is logged in or not, if they are not they get redirected to the login page
    redirect '/'
  end

  "Success :)"

end
