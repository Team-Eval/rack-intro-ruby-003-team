# app.rb

# lookup sinatra reloader

# 1. The post_message.rb must submit a POST request to localhost:9292
# (this running sinatra application). It should post
# to, from, content variables along with the request.
# Lookup how to submit POST requests using net/http
# and how to submit data along with that request

# 2. Build out the post '/' routes below in this file
# to take the incoming data and create a message from it
# you will need to lookup some basics on datamapper
# the getting started guide is a good place to start
# and you will need to lookup how to get POST
# data out of the request in sinatra

# 3. You need to edit messages.erb to iterate
# through all the @messages and print out the
# data
require 'sinatra'
require "sinatra/reloader"
require 'data_mapper'
require 'sqlite3'

require_relative 'models/message'

ProjectRoot = File.expand_path(File.dirname(__FILE__))

# this sets up an in-memory database
DataMapper.setup(:default, "sqlite:///#{ProjectRoot}/messages.db")

class MessageApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @messages = Message.all
    @body_class = "message"

    erb :messages
  end

  get '/migrate' do
    DataMapper.auto_migrate!
    "Database migrated! All tables reset."
  end

  post '/' do
    Message.create(:to => request[:to],
                   :from => request[:from],
                   :content => request[:content],
                   :created_at => Time.now)
    "success"
  end

  get '/delete/:id' do
    Message.get(params[:id].to_i).destroy if Message.get(params[:id].to_i)
    redirect to "/"
  end

end

DataMapper.finalize
DataMapper.auto_upgrade!
