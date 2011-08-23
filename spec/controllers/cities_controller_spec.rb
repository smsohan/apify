require 'spec_helper'

module Apify
  def apify_file
    FileUtils.mkdir_p(File.join(Rails.root, 'apify'))
    @@apify_file ||= File.open(File.join(Rails.root, 'apify', 'api.html'), 'w')
  end
  
  def api_index
    @@api_index ||= 1
  end
  
  def generate_api
    apify_file.puts "<pre>"        
    apify_file.puts api_index
    log_request response.request    
    apify_file.puts
    log_response response
    apify_file.puts "</pre>"
    @@api_index += 1
  end

  def log_request request
    apify_file.puts example.description
    apify_file.puts "REQUEST"
    request_method_path = "#{request.method} #{request.path}"
    request_method_path += "?#{request.query_parameters.to_param}" if request.query_parameters.present?
    apify_file.puts request_method_path
    apify_file.puts request.formats.join(',')
    apify_file.puts(JSON.pretty_generate(request.request_parameters.as_json)) if request.request_parameters.present?
  end

  def log_response response
    apify_file.puts "RESPONSE"
    apify_file.puts response.header['Content-Type']
    apify_file.puts JSON.pretty_generate(JSON.parse(response.body))
  end
end

describe CitiesController do
  include Apify
  describe 'cities api' do    

    before(:each) do
      City.create!(:name => 'Dhaka', :country => 'Bangladesh')
    end
      
    it 'Returns a json list of cities' do
      get :index, :my_data => 1, :format => :json    
      response.should be_success                        
    end      

    it 'Creates a city with json data' do
      post :create, :city => {:name => 'Toronto', :country => 'Canada'}, :format => :json    
      response.should be_success                        
    end      
    
    after(:each) do
      generate_api
    end
            
  end

end

