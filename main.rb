require 'sinatra'

set :public_folder, __dir__ + '/html'

get '/' do
  @index = File.read("html/index.html")
  erb("<%= @index %>")
end

get '/services/:serviceName' do
  "sevice #{params['serviceName']}"
end
