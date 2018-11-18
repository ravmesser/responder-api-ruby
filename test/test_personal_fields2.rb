require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test

  def test_get_personal_fileds
    res = @responder.get_personal_fields(@list_id)
    if assert(res.class == Hash, "this is not Hash class")
      if assert(res["PERSONAL_FIELDS"].length == 2, res.to_s + " \n the list doesn't have 2 peronal fields")
        assert(res["PERSONAL_FIELDS"][0]["NAME"] == "City", "the NAME of the first personal field is incorrect")
        assert(res["PERSONAL_FIELDS"][1]["NAME"] == "Date of birth", "the NAME of thre second personal field is incorrect")
      end
    end
  end
  
  def test_edit_personal_fields
    new_personal_fields = {
      0 => {
          "ID": @personal_fields_ids[0][0].to_s,
          "DEFAULT_VALUE": "Tel Aviv-Jaffa"
       },
      1 => {
          "ID": @personal_fields_ids[1][0].to_s,
          "NAME": "Date of birthday"
       }
    }
    res = @responder.edit_personal_fields(@list_id, new_personal_fields)
    if assert(res.class == Hash, "this is not Hash class")
      keys_array = ['INVALID_PERSONAL_FIELD_IDS', "EXISTING_PERSONAL_FIELD_NAMES"]
      hash_empty(res, keys_array, "edit_personal_fields")
      assert(res["UPDATED_PERSONAL_FIELDS"].length == 2, " edit_personal_fields() doesn't success")
    end
  end

end