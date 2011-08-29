module Apify

  def self.included base

    create_api_file   
    
    base.after(:each) do            
      generate_api
    end
    
  end
  
  def self.create_api_file    
    FileUtils.mkdir_p File.dirname(api_file_name)
    @@apify_file = File.open(api_file_name, 'w+')
  end

  def apify_file
    @@apify_file
  end
  
  def api_index
    @@api_index ||= 1
  end
  
  def generate_api
    apify_file.puts "<strong>" + example.description + "</strong>"
    apify_file.puts "<pre>"        
    apify_file.puts api_index
    log_request response.request    
    apify_file.puts
    log_response response
    apify_file.puts "</pre>"
    @@api_index += 1
  end

  def log_request request
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
  
  def self.api_file_name
    File.join(Rails.root, 'apify', "api.html")
  end
    
end
