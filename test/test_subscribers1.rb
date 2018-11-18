require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test
 
  def test_create_subscribers_error
    error_subscriber = {}
    res = @responder.create_subscribers(@list_id, error_subscriber)
    if assert(res.class == Hash)
      keys_array = ["EMAILS_INVALID", "EMAILS_EXISTING", "EMAILS_BANNED", "PHONES_INVALID", "PHONES_EXISTING", "SUBSCRIBERS_CREATED", "BAD_PERSONAL_FIELDS"]
      hash_empty(res, keys_array, "create_subscribers")
    end
  end

  def test_create_subscribers
    new_subscriber = {
      0 => {
          'EMAIL': "sub1@email.com",
          'NAME': "sub1"
      },
      1 => {
          'EMAIL': "sub2@email.com",
          'NAME': "sub2",
      }
    }
    
    res = @responder.create_subscribers(@list_id ,new_subscriber)
    if assert(res.class == Hash, "this Subscriber isn't Hash class")
      keys_array = ["ERRORS", "EMAILS_INVALID", "EMAILS_BANNED", "PHONES_INVALID", "PHONES_EXISTING", "BAD_PERSONAL_FIELDS"]
      subscribers_ids = res["SUBSCRIBERS_CREATED"] if hash_empty(res, keys_array, "create_subscribers")
    end
  end

end