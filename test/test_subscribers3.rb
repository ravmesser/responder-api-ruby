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
      
      res = @responder.create_subscribers(@list_id, new_subscriber)
      if assert(res.class == Hash, "this Subscriber isn't Hash class")
        isCreated = true
        isCreated = false unless assert(res["ERRORS"].empty?, "the Subscribers doesn't created - ERRORS")
        isCreated = false unless assert(res["EMAILS_INVALID"].empty?, "the Subscribers doesn't created - EMAILS_INVALID")
        isCreated = false unless assert(res["EMAILS_BANNED"].empty?, "the Subscribers doesn't created - EMAILS_BANNED")
        isCreated = false unless assert(res["PHONES_INVALID"].empty?, "the Subscribers doesn't created - PHONES_INVALID")
        isCreated = false unless assert(res["PHONES_EXISTING"].empty?, "the Subscribers doesn't created - PHONES_EXISTING")
        isCreated = false unless assert(res["BAD_PERSONAL_FIELDS"].empty?, "the Subscribers doesn't created - BAD_PERSONAL_FIELDS")
        @subscribers_ids = []
        @subscribers_ids = res["SUBSCRIBERS_CREATED"] if isCreated == true
      end
      puts "subscribers ids:"
      puts @subscribers_ids
      puts "end setup \n"
  end

  def test_delete_subscribers
    delete_subscribers = {
      0 => { 'EMAIL': "sub1@email.com" },
      1 => { 'ID': @subscribers_ids[1] }
    }      
    res = @responder.delete_subscribers( @list_id , delete_subscribers)
    pp res
    keys_array = ["INVALID_SUBSCRIBER_IDS", "INVALID_SUBSCRIBER_EMAILS"]
    if hash_empty(res, keys_array, "delete_subscribers")
      assert(res["DELETED_SUBSCRIBERS"].length == 2, "num of DELETED_SUBSCRIBERS != 2")
    end
  end

  def hash_empty(res, keys, test_name)
    is_empty = true
    keys.each do |key_name|
      is_empty = false if assert(res[key_name].empty?, "#{key_name} isn't empty in #{test_name}() ")
    end

    return is_empty
  end
end