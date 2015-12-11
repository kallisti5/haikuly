#!/usr/bin/env ruby

gem 'sinatra'

require 'sinatra'
require 'json'
require 'fileutils'

configure do
  set :location => "/tmp/haikuly"
end

def safe(str)
  if str.length > 512
    return false
  end
  if str[/[a-zA-Z]+/] != str
    return false
  end
  return true
end

get '/version' do
  return { api: 1, server: '1.0.0' }.to_json
end

get '/repo' do
  return {test: { arch: "x86_64" } }.to_json
end

post '/repo' do
  if !params[:name] or !safe(params[:name])
    status 400
    return {error: "Invalid repo name!"}.to_json
  end
  name = params[:name]
  if Dir.exist?("#{settings.location}/#{name}")
    status 405
    return {error: "Repository already exists!"}.to_json
  end
  FileUtils.mkdir_p(settings.location)
  FileUtils.mkdir("#{settings.location}/#{name}")
end

delete '/repo/:name' do
  if !params[:name] or !safe(params[:name])
    status 400
    return {error: "Invalid repo name!"}.to_json
  end
  name = params[:name]
  if !Dir.exist?("#{settings.location}/#{name}")
    status 405
    return {error: "Repository already exists!"}.to_json
  end
  FileUtils.rm_rf("#{settings.location}/#{name}")
end
