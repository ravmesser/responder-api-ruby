require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test
  def test_edit_list
    new_list = {
      "DESCRIPTION": 'The New List',
      "REMOVE_TITLE": 'Bye Bye! New',
      "SITE_NAME": 'tocodenew',
      "SITE_URL": 'http://www.espondernew.co.il',
      "LOGO": 'http://www.respondernew.co.il/images/wn_06.gif',
      "SENDER_NAME": 'SomeoneNew',
      "SENDER_EMAIL": 'someonenew@responder.co.il',
      "SENDER_ADDRESS": 'Somewhere At Responder New',
      "NAME": 'english_new_name',
      "AUTH_MAIL_SUBJECT": '',
      "AUTH_MAIL_BODY": '',
      "AUTH_MAIL_LINK": '',
      "AUTH_MAIL_DIR": '',
      "AUTH_MAIL_PAGE": '',
      "AUTH_MAIL_FORM": '',
      "AUTH_MAIL_MANUAL": '',
      "EMAIL_NOTIFY": ['second@responder.co.il'],
      "AUTOMATION": []
    }
    res = @responder.edit_list(@list_id, new_list)
    return unless assert(res.class == Hash, 'this is not Hash class')

    keys_array = %w[ERRORS INVALID_EMAIL_NOTIFY INVALID_LIST_IDS]
    hash_empty(res, keys_array, 'create_personal_fields')
    assert(res['SUCCESS'], " edit_list() doesn't success")
  end
end
