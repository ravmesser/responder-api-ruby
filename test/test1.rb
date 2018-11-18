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
    # puts @list_id

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
      # @subscribers_ids = res["SUBSCRIBERS_CREATED"] if hash_empty(res, keys_array, "create_subscribers")
      @subscribers_ids = res["SUBSCRIBERS_CREATED"] if assert(res["ERRORS"].empty?, "ERRORS isn't empty in create_subscribers() ")
    end

    #create personal fields
    new_personal_fields = {
      0 => {
          "NAME": "City",
          "DEFAULT_VALUE": "Tel Aviv",
          "TYPE": 0,
      },
      1 => {
          "NAME": "Date of birth",
          "TYPE": 1
        }
    }

    res = @responder.create_personal_fields(@list_id ,new_personal_fields)
    if assert(res.class == Hash, "this Personal Fields aren't Hash class")
      @personal_fields_ids = res["CREATED_PERSONAL_FIELDS"] if assert(res["EXISTING_PERSONAL_FIELD_NAMES"].empty?, "EXISTING_PERSONAL_FIELD_NAMES isn't empty in create_personal_fields() ")
    end
  end

  def test_get_list
    res = @responder.get_list(@list_id)
    assert(res["INVALID_LIST_IDS"].empty?, "the list doesn't exist") if assert(res.class == Hash, "this is not Hash class")
  end

  # def test_list
  #   #create
  #   error_list = {}
  #   new_list = {
  #     "DESCRIPTION": "Test List",
  #     "REMOVE_TITLE": "Bye Bye! (REMOVE_TITLE)",
  #     "SITE_NAME": "tocode",
  #     "SITE_URL": "http://www.tocode.co.il",
  #     "LOGO": "",
  #     "SENDER_NAME": "SENDER_NAME",
  #     "SENDER_EMAIL": "SENDER_EMAIL@responder.co.il",
  #     "SENDER_ADDRESS": "SENDER_ADDRESS pyhsical address",
  #     "NAME": "list NAME",
  #     "AUTH_MAIL_SUBJECT": "",
  #     "AUTH_MAIL_BODY": "",
  #     "AUTH_MAIL_LINK": "",
  #     "AUTH_MAIL_DIR": "",
  #     "AUTH_MAIL_PAGE": "",
  #     "AUTH_MAIL_FORM": "",
  #     "AUTH_MAIL_MANUAL": "",
  #     "EMAIL_NOTIFY": ["first@responder","second@responder.co.il"],
  #     "AUTOMATION": [123457,123458]
  #   }
  #   res = @responder.create_list(error_list)
  #   assert(res.class == Array)
  #   res = @responder.create_list(new_list)
  #   list_id = res["LIST_ID"] if assert(res["ERRORS"].empty?, "the list doesn't created") if assert(res.class == Hash, "this is not Hash class")
  #   # puts list_id
    
  #   # get
  #   res = @responder.get_list(list_id)
  #   # pp res
  #   assert(res["INVALID_LIST_IDS"].empty?, "the list doesn't exist") if assert(res.class == Hash, "this is not Hash class")

  #   # edit
  #   new_list = {
  #     "DESCRIPTION": "The New List",
  #     "REMOVE_TITLE": "Bye Bye!",
  #     "SITE_NAME": "tocode",
  #     "SITE_URL": "http://www.esponder.co.il",
  #     "LOGO": "http://www.responder.co.il/images/wn_06.gif",
  #     "SENDER_NAME": "Someone",
  #     "SENDER_EMAIL": "someone@responder.co.il",
  #     "SENDER_ADDRESS": "Somewhere At Responder",
  #     "NAME": "english_name",
  #     "AUTH_MAIL_SUBJECT": "",
  #     "AUTH_MAIL_BODY": "",
  #     "AUTH_MAIL_LINK": "",
  #     "AUTH_MAIL_DIR": "",
  #     "AUTH_MAIL_PAGE": "",
  #     "AUTH_MAIL_FORM": "",
  #     "AUTH_MAIL_MANUAL": "",
  #     "EMAIL_NOTIFY": ["second@responder.co.il"],
  #     "AUTOMATION": []
  #   }
  #   res = @responder.edit_list(list_id, new_list)
  #   if assert(res.class == Hash, "this is not Hash class")
  #     assert(res["ERRORS"].empty?, "there is ERRORS in edit_list() ")
  #     assert(res["INVALID_EMAIL_NOTIFY"].empty?, "there is INVALID_EMAIL_NOTIFY in edit_list() ") 
  #     assert(res["INVALID_LIST_IDS"].empty?, "there is INVALID_LIST_IDS in edit_list() ") 
  #     assert(res["SUCCESS"], " edit_list() doesn't success") 
  #   end


  #   #delete
  #   res = @responder.delete_list(list_id)
  #   assert(res["DELETED_LIST_ID"] == list_id , "the list doesn't deleted") if assert(res.class == Hash, "this is not Hash class")
  # end


  def hash_empty(res, keys, test_name)
    is_empty = true
    keys.each do |key_name|
      is_empty = false if assert(res[key_name].empty?, "#{key_name} isn't empty in #{test_name}() ")
    end

    return is_empty
  end


end