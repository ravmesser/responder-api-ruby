require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test
  def test_delete_subscribers
    delete_subscribers = {
      0 => { 'EMAIL': 'sub1@email.com' },
      1 => { 'ID': @subscribers_ids[1].to_i }
    }
    res = @responder.delete_subscribers(@list_id, delete_subscribers)
    keys_array = %w[INVALID_SUBSCRIBER_IDS INVALID_SUBSCRIBER_EMAILS]
    assert(res['DELETED_SUBSCRIBERS'].length == 2, 'num of DELETED_SUBSCRIBERS != 2') if hash_empty(res, keys_array, 'delete_subscribers')
  end
end
