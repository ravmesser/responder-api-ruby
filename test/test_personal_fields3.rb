require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test

  def test_delete_personal_fields
    delete_personal_fields = {
      0 => { 'ID': @personal_fields_ids[0][0] },
      1 => { 'ID': @personal_fields_ids[1][0] }
    }
    res = @responder.delete_personal_fields( @list_id , delete_personal_fields)
    assert(res["INVALID_FIELD_IDS"].empty?, "INVALID_FIELD_IDS isn't empty in delete_personal_fields() ")
    assert(res["DELETED_FIELDS"].length == 2, "num of DELETED_SUBSCRIBERS != 2")
  end

  def test_delete_personal_fields_fail
    delete_personal_fields_fail = {
      0 => { 'ID': 123456789 },
      1 => { 'ID': 0 }
    }
    res = @responder.delete_personal_fields( @list_id , delete_personal_fields_fail)
    assert(res["DELETED_FIELDS"].empty?, "DELETED_FIELDS isn't empty in delete_personal_fields() ")
    assert(res["INVALID_FIELD_IDS"].length == 2, "num of INVALID_FIELD_IDS != 2")
  end

end