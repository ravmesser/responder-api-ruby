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

  def create_list(desc, sm, se, sa)
    post_JSON = {'info' => 
      JSON.generate({
        'DESCRIPTION': desc,
        'SENDER_NAME': sm,
        'SENDER_EMAIL': se,
        'SENDER_ADDRESS': sa
      })
    }

    response = @access_token.request(:post, "/v1.0/lists", post_JSON)
    rsp = JSON.parse(response.body)
    return rsp

  end

  def edit_list(id, desc)
    put_JSON = {'info' => 
      JSON.generate({
        'DESCRIPTION': desc
      })
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
  def get_personal_fields

  end

  def create_personal_field
    
  end

  def edit_personal_field(id)
    
  end

  def delete_personal_field(id)
    
  end
  # endregion Personal Fields



end