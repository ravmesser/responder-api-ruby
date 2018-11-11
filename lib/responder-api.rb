require 'rubygems'
require 'oauth'
require 'json'
require 'optparse'
require 'pp'

class Responder
  def initialize(ck, cs, uk, us)
    consumer = OAuth::Consumer.new(ck,cs, :site => "http://api.responder.co.il")
    @access_token = OAuth::AccessToken.new(consumer, uk, us)
  end

  def get_lists
    response = @access_token.request(:get, "/v1.0/lists")
    rsp = JSON.parse(response.body)
    return rsp
  end

  def create_list
    
  end

  def edit_list(id)
    
  end

  def delete_list(id)
    
  end


end