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

      #create subscribers
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
        @subscribers_ids = res["SUBSCRIBERS_CREATED"] if hash_empty(res, keys_array, "create_subscribers")
      end
      puts "subscribers ids:"
      puts @subscribers_ids
      puts "end setup \n"
  end

  def test_get_subscribers
    res = @responder.get_subscribers(@list_id)
    pp res
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
      # pp res
      keys_array = ['INVALID_SUBSCRIBER_IDENTIFIERS', "EMAILS_INVALID", "EMAILS_EXISTED", "EMAILS_BANNED", "PHONES_INVALID", "PHONES_EXISTING", "BAD_PERSONAL_FIELDS"]
      hash_empty(res, keys_array, "edit_subscribers")
      if assert(res["SUBSCRIBERS_UPDATED"].length == 2, " edit_subscribers() doesn't success")
        assert(res["SUBSCRIBERS_UPDATED"][0] == "sub1@email.com", "sub1@email.com doesn't update correctly") 
        assert(res["SUBSCRIBERS_UPDATED"][1] == "sub2@email.com", "sub2@email.com doesn't update correctly") 
      end 
    end
  end
end