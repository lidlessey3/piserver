require 'sinatra'
require 'digest/sha1'

enable :sessions

set :public_folder, __dir__ + '/html'

get '/' do
  if(session[:logged_in]) # I check if the user is already autenticated
    redirect '/dashboard' #if it is I redirect it to the dashboard
  elsif (!session[:random_string])  # Othewise I check if I already created its personal key, if I did not I create it
    length = rand(80) + 1   #generate the length of a random string
    @r_string = (0...length).map{((rand(2)==1?65:97) + rand(25)).chr}.join   #generates the random string using somethig that is similar to streams
    session[:random_string] = @r_string  # saves the string to the session
  end

  @index = File.read("html/index.html") #reads the file as a string
  erb("<%= @index %>")  #returns that string to the browser
end

get '/login' do
  redirect '/'
end

post '/login' do 
  @r_string = session[:random_string]  #I recuperate the random string
  if(!@r_string)  # if is not set I redirect to the login page
    redirect '/'
  end

  password = "password" # the password

  server_hash = Digest::SHA1.hexdigest(password + @r_string)  #computes the correct hash

end

get '/services/:serviceName' do
  "sevice #{params['serviceName']}"
end
