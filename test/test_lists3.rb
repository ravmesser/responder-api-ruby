require 'minitest/autorun'
require 'pp'
require 'responder-api'
require 'yaml'

class ResponderTest < Minitest::Test
  def test_delete_list
    res = @responder.delete_list(@list_id)

    assert(res['DELETED_LIST_ID'] == @list_id, "the list doesn't deleted") if assert(res.class == Hash, 'this is not Hash class')
  end
end
