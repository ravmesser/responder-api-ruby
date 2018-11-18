require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test
  def setup
    tokens = YAML.load_file("./test/tokens.yml")
    @responder = Responder.new(tokens["Client_key"], tokens["Client_secret"], tokens["User_key"], tokens["User_secret"])
    #create list
    new_list = {
      "DESCRIPTION": "Test List",
      "REMOVE_TITLE": "Bye Bye! (REMOVE_TITLE)",
      "SITE_NAME": "tocode",
      "SITE_URL": "http://www.tocode.co.il",
      "LOGO": "",
      "SENDER_NAME": "SENDER_NAME",
      "SENDER_EMAIL": "SENDER_EMAIL@responder.co.il",
      "SENDER_ADDRESS": "SENDER_ADDRESS pyhsical address",
      "NAME": "list NAME",
      "AUTH_MAIL_SUBJECT": "",
      "AUTH_MAIL_BODY": "",
      "AUTH_MAIL_LINK": "",
      "AUTH_MAIL_DIR": "",
      "AUTH_MAIL_PAGE": "",
      "AUTH_MAIL_FORM": "",
      "AUTH_MAIL_MANUAL": "",
      "EMAIL_NOTIFY": ["first@responder","second@responder.co.il"],
      "AUTOMATION": [123457,123458]
    }
    res = @responder.create_list(new_list)
    @list_id = res["LIST_ID"] if assert(res["ERRORS"].empty?, "the list doesn't created") if assert(res.class == Hash, "this is not Hash class")
    puts @list_id
  end

  def test_create_subscribers_error
    error_subscriber = {}
    res = @responder.create_subscribers(@list_id, error_subscriber)
    if assert(res.class == Hash)
      keys_array = ["EMAILS_INVALID", "EMAILS_EXISTING", "EMAILS_BANNED", "PHONES_INVALID", "PHONES_EXISTING", "SUBSCRIBERS_CREATED", "BAD_PERSONAL_FIELDS"]
      hash_empty(res, keys_array, "create_subscribers")
    end
    pp res

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
    puts "subscribers ids:"
    puts subscribers_ids
  end

  def hash_empty(res, keys, test_name)
    is_empty = true
    keys.each do |key_name|
      is_empty = false if assert(res[key_name].empty?, "#{key_name} isn't empty in #{test_name}() ")
    end

    return is_empty
  end
end