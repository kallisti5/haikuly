# spec/app_spec.rb
require File.expand_path '../spec_helper.rb', __FILE__

describe "Haikuly Package Server" do
  it "should provide versioning info" do
    get '/version'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json != nil)
    expect(json.fetch("api"))
    expect(json.fetch("server"))
  end

  it "should list repositories" do
    get '/repo'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json != nil)
  end

  it "should manage repositories" do
    post '/repo', :name => "test"
    expect(last_response).to be_ok
    delete '/repo/test'
    expect(last_response).to be_ok
  end
end
