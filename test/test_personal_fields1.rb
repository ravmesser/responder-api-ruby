require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test

  def test_create_personal_fileds_error
    error_personal_fields = {}
    res = @responder.create_personal_fields(@list_id, error_personal_fields)
    if assert(res.class == Hash, "this Personal Fields aren't Hash class")
      keys_array = ["CREATED_PERSONAL_FIELDS", "EXISTING_PERSONAL_FIELD_NAMES"]
      hash_empty(res, keys_array, "create_personal_fields")
    end
  end

  def test_create_personal_fileds
    new_personal_fields = {
      0 => {
          "NAME": "Name",
          "DEFAULT_VALUE": "Israel Israeli",
          "DIR": "rtl",
          "TYPE": 0,
      },
      1 => {
          "NAME": "Age",
          "TYPE": 1
       }
    }

    res = @responder.create_personal_fields(@list_id ,new_personal_fields)
    if assert(res.class == Hash, "this Personal Fields aren't Hash class")
      personal_fields_ids = res["CREATED_PERSONAL_FIELDS"] if assert(res["EXISTING_PERSONAL_FIELD_NAMES"].empty?, res.to_s + " \n EXISTING_PERSONAL_FIELD_NAMES isn't empty in create_personal_fields() ")
    end
  end

end