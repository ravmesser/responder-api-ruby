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

  # region Lists
  def get_lists
    return sendRequest(:get, '', '', '', {})
  end

  def get_list(id)
    return sendRequest(:get, '', "?list_ids=" + id.to_s, id, {})

  end

  def create_list(args = {})
    return sendRequest(:post, 'info', '', '', args)
  end

  def edit_list(id, args = {})
    return sendRequest(:put, 'info', "/" + id.to_s, id, args)
  end

  def delete_list(id)
    return sendRequest(:delete, 'info', "/" + id.to_s, id, {})

  end
  # endregion Lists

  # region Subscribers
  def get_subscribers(id)
    response = @access_token.request(:get, "/v1.0/lists/" + id.to_s + "/subscribers")
    rsp = JSON.parse(response.body)
    return rsp
  end

  def create_subscribers(id, args = {} )
    post_JSON = {'subscribers' => 
      JSON.generate(args)
    }

    response = @access_token.request(:post, "/v1.0/lists/"  + id.to_s + "/subscribers" , post_JSON)
    rsp = JSON.parse(response.body)
    return rsp
  end

  def edit_subscribers(id, args)
    put_JSON = {'subscribers' => 
      JSON.generate(args)
    }

    response = @access_token.request(:put, "/v1.0/lists/"  + id.to_s + "/subscribers" , put_JSON)
    rsp = JSON.parse(response.body)
    return rsp
  end

  def delete_subscribers(id, args)
    delete_JSON = {'subscribers' => 
      JSON.generate(args)
    }

    response = @access_token.request(:post, "/v1.0/lists/"  + id.to_s + "/subscribers?method=delete" , delete_JSON)
    rsp = JSON.parse(response.body)
    return rsp
  end
  # endregion Subscribers


  # region Personal Fields
  def get_personal_fields(id)
    response = @access_token.request(:get, "/v1.0/lists/" + id.to_s + "/personal_fields")
    rsp = JSON.parse(response.body)
    return rsp
  end

  def create_personal_fields(id, args = {} )
    post_JSON = {'personal_fields' => 
      JSON.generate(args)
    }

    response = @access_token.request(:post, "/v1.0/lists/"  + id.to_s + "/personal_fields" , post_JSON)
    rsp = JSON.parse(response.body)
    return rsp
  end

  def edit_personal_fields(id, args)
    put_JSON = {'personal_fields' => 
      JSON.generate(args)
    }

    response = @access_token.request(:put, "/v1.0/lists/"  + id.to_s + "/personal_fields" , put_JSON)
    rsp = JSON.parse(response.body)
    return rsp
  end

  def delete_personal_fields(id, args)
    delete_JSON = {'personal_fields' => 
      JSON.generate(args)
    }

    response = @access_token.request(:post, "/v1.0/lists/"  + id.to_s + "/personal_fields?method=delete" , delete_JSON)
    rsp = JSON.parse(response.body)
    return rsp
  end
  # endregion Personal Fields

  def sendRequest(type, object_name = "", query = "", id = "", args = {})
    if (!(args == {}) )
      json_obj = { object_name => 
        JSON.generate(args)
      }
    end

    # query = ""
    # if object_name == 'info'
    #   object_name = "" 
    #   query = "/" + id.to_s + "/" + object_name
    # end
    # query = "/" + id.to_s + "/" + object_name unless object_name == ''
    # query = "?list_ids=" + id.to_s if object_name == 'list'

    response = @access_token.request(type, "/v1.0/lists"  + query , json_obj)
    response = JSON.parse(response.body) unless response.class == String
    return response
  end


end