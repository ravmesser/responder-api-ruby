require 'minitest/autorun'
require 'pp'
require 'rav-meser-api'
require 'yaml'

class RavMeserTest < Minitest::Test
  
  def test_get_tokens 
    tokens = YAML.load_file('./test/tokens.yml')

    token_result = RavMeser.get_tokens(tokens['client_key'], tokens['client_secret'], 834259)

    assert(token_result.key?("TOKENS"))
    assert_equal("62C5AA89820E88B528BBC170D005DB5B", token_result.dig("TOKENS","KEY"))
    assert_equal("8662F470B81B73E635BA6CCA9D47A1CD", token_result.dig("TOKENS","SECRET"))
  end

  def test_get_tokens_by_wrong_user_id
    tokens = YAML.load_file('./test/tokens.yml')

    token_result = RavMeser.get_tokens(tokens['client_key'], tokens['client_secret'], nil)
    
    assert(token_result.dig(:TOKENS,:KEY).nil?)
    assert(token_result.dig(:TOKENS,:SECRET).nil?)
  end

end