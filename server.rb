#!/usr/bin/env ruby

gem 'sinatra'

require 'sinatra'
require 'json'
require 'fileutils'
require 'pp'

@repo_base = "/tmp/haikuly"

configure do
  set :location => @repo_base
  set :tools => "#{File.dirname(__FILE__)}/tools"
  set :lock => true
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

def repo_info(path)
  {"name": path.split('/').last}
end

# BOOT UP
FileUtils.mkdir_p("#{@repo_base}")

get '/version' do
  return { api: 1, server: '1.0.0' }.to_json
end

get '/repo' do
  results = Array.new
  Dir.glob("#{settings.location}/*/").each do |repo|
    results.push(repo_info(repo))
  end
  return results.to_json
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

get '/repo/:name' do
  if !params[:name] or !safe(params[:name])
    status 400
    return {error: "Invalid repo name!"}.to_json
  end
  name = params[:name]
  if !Dir.exist?("#{settings.location}/#{name}")
    status 405
    return {error: "Repository doesn't exist!"}.to_json
  end
  return repo_info("#{settings.location}/#{name}").to_json
end

delete '/repo/:name' do
  if !params[:name] or !safe(params[:name])
    status 400
    return {error: "Invalid repo name!"}.to_json
  end
  name = params[:name]
  if !Dir.exist?("#{settings.location}/#{name}")
    status 405
    return {error: "Repository doesn't exist!"}.to_json
  end
  FileUtils.rm_rf("#{settings.location}/#{name}")
end
