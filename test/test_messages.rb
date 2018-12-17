require 'minitest/autorun'
require 'pp'
require 'rav-meser-api'
require 'yaml'

class RavMeserTest < Minitest::Test
  def test_create_and_send_message
    new_message = {
      'TYPE' => 1, # 1 for "messer boded", 0 for "sidrat messarim", 2 for "mevusas ta'arich"
      'BODY_TYPE' => 0, # 0 for regular HTML editor (affects the type of editor used in the website)
      'SUBJECT' => 'message subject3',
      'BODY' => '<h1> Hello World! </h1> <p>message HTML body \n new line</p>',
      'LANGUAGE' => 'hebrew', # -optional- defaults to 'english'
      'CHECK_LINKS' => 1 # -opitonal- defaults to 0; if set to 1, responder will build statistics of opened messages, clicked links, etc. (called "nitu'ah kishurim")
    }

    res = @responder.create_and_send_message(@list_id, new_message)
    return unless assert(res.class == Hash, "this Message isn't Hash class")

    assert(res['MESSAGE_SENT'], "MESSAGE_SENT = #{res['MESSAGE_SENT']}")
  end
end
