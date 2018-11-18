require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test

  def test_get_subscribers
    res = @responder.get_subscribers(@list_id)
    if assert(res.class == Array, "this is not Hash class")
      if assert(res.length == 2, "the list doesn't have 2 subscribers")
        assert(res[0]["EMAIL"] == "sub1@email.com", "the EMAIL of sub1 incorrect")
        assert(res[0]["NAME"] == "sub1", "the NAME of sub1 incorrect")
        assert(res[1]["EMAIL"] == "sub2@email.com", "the EMAIL of sub2 incorrect")
        assert(res[1]["NAME"] == "sub2", "the NAME of sub2 incorrect")
      end
    end

  end

  def test_edit_subscribers
    new_subscribers = {
      0 => {
          'IDENTIFIER': "sub1@email.com",
          'NAME': "sub1NewName",
          # 'PERSONAL_FIELDS': {'111' => 'data to field id: 111', '222' => 'data to field id: 222'}
      },
      1 => {
          'IDENTIFIER': "sub2@email.com",
          'NAME': "sub2",
      }
    }                                                   
    res = @responder.edit_subscribers(@list_id, new_subscribers)
    if assert(res.class == Hash, "this is not Hash class")
      keys_array = ['INVALID_SUBSCRIBER_IDENTIFIERS', "EMAILS_INVALID", "EMAILS_EXISTED", "EMAILS_BANNED", "PHONES_INVALID", "PHONES_EXISTING", "BAD_PERSONAL_FIELDS"]
      hash_empty(res, keys_array, "edit_subscribers")
      if assert(res["SUBSCRIBERS_UPDATED"].length == 2, " edit_subscribers() doesn't success")
        assert(res["SUBSCRIBERS_UPDATED"][0] == "sub1@email.com", "sub1@email.com doesn't update correctly") 
        assert(res["SUBSCRIBERS_UPDATED"][1] == "sub2@email.com", "sub2@email.com doesn't update correctly") 
      end 
    end
  end

end