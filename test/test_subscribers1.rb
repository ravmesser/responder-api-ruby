require 'minitest/autorun'
require 'pp'
require 'rav-meser-api'
require 'yaml'

class RavMeserTest < Minitest::Test
  def test_create_subscribers_error
    error_subscriber = {}
    res = @responder.create_subscribers(@list_id, error_subscriber)
    return unless assert(res.class == Hash)

    keys_array = %w[EMAILS_INVALID EMAILS_EXISTING EMAILS_BANNED PHONES_INVALID PHONES_EXISTING SUBSCRIBERS_CREATED BAD_PERSONAL_FIELDS]
    hash_empty(res, keys_array, 'create_subscribers')
  end

  def test_create_subscribers
    new_subscriber = {
      0 => {
        'EMAIL': 'sub1@email.com',
        'NAME': 'sub1'
      },
      1 => {
        'EMAIL': 'sub3@email.com',
        'NAME': 'sub3'
      }
    }

    res = @responder.create_subscribers(@list_id, new_subscriber)
    return unless assert(res.class == Hash, "this Subscriber isn't Hash class")

    keys_array = %w[ERRORS EMAILS_INVALID EMAILS_BANNED PHONES_INVALID PHONES_EXISTING BAD_PERSONAL_FIELDS]
    hash_empty(res, keys_array, 'create_subscribers')
    assert(res['EMAILS_EXISTING'].length == 1, 'EMAILS_EXISTING.length != 1')
    assert(res['SUBSCRIBERS_CREATED'].length == 1, 'SUBSCRIBERS_CREATED.length != 1')
  end
end
