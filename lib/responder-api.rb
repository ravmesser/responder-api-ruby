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
    response = @access_token.request(:get, "/v1.0/lists")
    rsp = JSON.parse(response.body.force_encoding('UTF-8'))
    return rsp
  end

  def get_list(id)
    response = @access_token.request(:get, "/v1.0/lists?list_ids=" + id.to_s)
    rsp = JSON.parse(response.body)
    return rsp
  end

  def create_list(args = {})
    post_JSON = {'info' => 
      JSON.generate(args)
    }

    response = @access_token.request(:post, "/v1.0/lists", post_JSON)
    rsp = JSON.parse(response.body)
    return rsp

    # return sendRequest(:post, 'info', '', args)
  end

  def edit_list(id, args = {})
    put_JSON = {'info' => 
      JSON.generate(args)
    }

    response = @access_token.request(:put, "/v1.0/lists/" + id.to_s , put_JSON)
    rsp = JSON.parse(response.body)
    return rsp
  end

  def delete_list(id)
    response = @access_token.request(:delete, "/v1.0/lists/" + id.to_s)
    rsp = JSON.parse(response.body)
    return rsp
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

  def sendRequest(type, object_name = "", id = "", args = {})
    if (!(args == {}) )
      json_obj = { object_name => 
        JSON.generate(args)
      }
    end

    object_name = '' if object_name == 'info'
    object_name = "/" + object_name unless object_name == ''
    # object_name == '' ? () : (object_name = "/" + object_name)

    response = @access_token.request(type, "/v1.0/lists/"  + id.to_s + object_name , json_obj)
    rsp = JSON.parse(response.body)
    return rsp
  end


end