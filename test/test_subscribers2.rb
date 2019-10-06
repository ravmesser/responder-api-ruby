require 'minitest/autorun'
require 'pp'
require 'rav-meser-api'
require 'yaml'

class RavMeserTest < Minitest::Test
  def test_get_subscribers
    res = @responder.get_subscribers(@list_id)
    return unless assert(res.class == Array, 'this is not Hash class')

    return unless assert(res.length == 2, "the list doesn't have 2 subscribers")

    assert(res[0]['EMAIL'] == 'sub1@email.com', 'the EMAIL of sub1 incorrect')
    assert(res[0]['NAME'] == 'sub1', 'the NAME of sub1 incorrect')
    assert(res[1]['EMAIL'] == 'sub2@email.com', 'the EMAIL of sub2 incorrect')
    assert(res[1]['NAME'] == 'sub2', 'the NAME of sub2 incorrect')
  end

  def test_edit_subscribers
    new_subscribers = {
      0 => {
        'IDENTIFIER': 'sub1@email.com',
        'NAME': 'sub1NewName'
      },
      1 => {
        'IDENTIFIER': 'sub2@email.com',
        'NAME': 'sub2'
      }
    }
    res = @responder.edit_subscribers(@list_id, new_subscribers)
    return unless assert(res.class == Hash, 'this is not Hash class')

    keys_array = %w[INVALID_SUBSCRIBER_IDENTIFIERS EMAILS_INVALID EMAILS_EXISTED EMAILS_BANNED PHONES_INVALID PHONES_EXISTING BAD_PERSONAL_FIELDS]
    hash_empty(res, keys_array, 'edit_subscribers')
    return unless assert(res['SUBSCRIBERS_UPDATED'].length == 2, " edit_subscribers() doesn't success")

    assert(res['SUBSCRIBERS_UPDATED'][0] == 'sub1@email.com', "sub1@email.com doesn't update correctly")
    assert(res['SUBSCRIBERS_UPDATED'][1] == 'sub2@email.com', "sub2@email.com doesn't update correctly")
  end

  def test_upsert_subscribers
    new_old_subscribers = {
      0 => {
        'EMAIL': 'sub2@email.com',
        'NAME': 'sub2NewName',
        'PHONE': '0501234567'
      },
      1 => {
        'EMAIL': 'sub3@email.com',
        'NAME': 'sub3NewName'
      },
      2 => {
        'EMAIL': 'sub1@email.com',
        'NAME': 'sub1NewName',
        'PHONE': '0501234568'
      }
    }
    res = @responder.upsert_subscribers(@list_id, new_old_subscribers)
    assert(res.class == Array, 'this is not Array class')
    assert(res.length == 2) # the first index is the response of the create_subscribers
                            # the second index is the response of the update_subscribers

    create_response = res[0]
    update_response = res[1]

    keys_array = %w[EMAILS_INVALID EMAILS_BANNED PHONES_INVALID PHONES_EXISTING BAD_PERSONAL_FIELDS]
    hash_empty(create_response, keys_array, 'create_subscribers')
    keys_array = %w[INVALID_SUBSCRIBER_IDENTIFIERS EMAILS_INVALID EMAILS_EXISTED EMAILS_BANNED PHONES_INVALID PHONES_EXISTING BAD_PERSONAL_FIELDS]
    hash_empty(update_response, keys_array, 'create_subscribers')

    assert(create_response['SUBSCRIBERS_CREATED'].length == 1, " create_subscribers() doesn't success")
    assert(update_response['SUBSCRIBERS_UPDATED'].length == 2, " update_subscribers() doesn't success")
  end

  def test_upsert_subscriber_do_update
    new_old_subscriber = {
      0 => {
        'EMAIL': 'sub2@email.com',
        'NAME': 'sub2NewName',
        'PHONE': '0501234567'
      }
    }
    res = @responder.upsert_subscriber(@list_id, new_old_subscriber)
    assert(res.class == Array, 'this is not Array class')
    assert(res.length == 2) # the first index is the response of the create_subscribers
                            # the second index is the response of the update_subscribers

    create_response = res[0]
    update_response = res[1]

    keys_array = %w[SUBSCRIBERS_CREATED EMAILS_INVALID EMAILS_BANNED PHONES_INVALID PHONES_EXISTING BAD_PERSONAL_FIELDS]
    hash_empty(create_response, keys_array, 'create_subscribers')
    keys_array = %w[INVALID_SUBSCRIBER_IDENTIFIERS EMAILS_INVALID EMAILS_EXISTED EMAILS_BANNED PHONES_INVALID PHONES_EXISTING BAD_PERSONAL_FIELDS]
    hash_empty(update_response, keys_array, 'create_subscribers')

    assert(create_response['EMAILS_EXISTING'].length == 1, " create_subscribers() doesn't success")
    assert(update_response['SUBSCRIBERS_UPDATED'].length == 1, " update_subscribers() doesn't success")
  end

  def test_upsert_subscriber_do_create
    new_old_subscriber = {
      0 => {
        'EMAIL': 'sub3@email.com',
        'NAME': 'sub3',
        'PHONE': '0501234567'
      }
    }
    res = @responder.upsert_subscriber(@list_id, new_old_subscriber)
    assert(res.class == Array, 'this is not Array class')
    assert(res.length == 2) # the first index is the response of the create_subscribers
                            # the second index is the response of the update_subscribers

    create_response = res[0]
    update_response = res[1]

    keys_array = %w[EMAILS_EXISTING EMAILS_INVALID EMAILS_BANNED PHONES_INVALID PHONES_EXISTING BAD_PERSONAL_FIELDS ERRORS]
    hash_empty(create_response, keys_array, 'create_subscribers')
    assert_equal(update_response, {})

    assert(create_response['SUBSCRIBERS_CREATED'].length == 1, " create_subscribers() doesn't success")
  end
end
