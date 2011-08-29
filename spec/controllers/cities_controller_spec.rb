require 'spec_helper'

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
    
    describe 'New city' do
      it 'Creates a city with json data' do
        post :create, :city => {:name => 'Toronto', :country => 'Canada'}, :format => :json    
        response.should be_success                        
      end      
    end
    
  end

end

