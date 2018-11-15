require 'minitest/autorun'
require 'pp'
require 'responder-api'
require_relative  "tokens"

class ResponderTest < Minitest::Test
  # def startup
  #   @@list_id = 0
  # end

  def setup
      @responder = Responder.new(Client_key, Client_secret, User_key, User_secret)
  end

  def test_list
    #create
    error_list = {}
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
    res = @responder.create_list(error_list)
    assert(res.class == Array)
    res = @responder.create_list(new_list)
    list_id = res["LIST_ID"] if assert(res["ERRORS"].empty?, "the list doesn't created") if assert(res.class == Hash, "this is not Hash class")
    puts list_id
    
    # get
    res = @responder.get_list(list_id)
    pp res
    assert(res["INVALID_LIST_IDS"].empty?, "the list doesn't exist") if assert(res.class == Hash, "this is not Hash class")

    #delete
    res = @responder.delete_list(list_id)
    puts res if assert(res["DELETED_LIST_ID"] == list_id , "the list doesn't deleted") if assert(res.class == Hash, "this is not Hash class")
    
  end





end