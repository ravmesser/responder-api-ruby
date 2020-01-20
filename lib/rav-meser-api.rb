require 'rubygems'
require 'oauth'
require 'json'
require 'optparse'
require 'uri'
require 'pp'
# require 'pry'

# gem class name RavMeser
class RavMeser
  # initialize new RavMeser Object
  #
  # Example:
  #   >> RavMeser.new(MNFDKRHUI2398RJ2O3R, NF932URH29837RY923JN, NF2983HFOIMNW2983H32, NFG8927RH238RH2)
  #
  # Arguments:
  #   client_key: (String) Client Key
  #   client_secret: (String) Client Secret
  #   user_key: (String) User Key
  #   user_secret: (String) User Secret
  #.  endpoint: (String) Api endpoint
  def initialize(client_key, client_secret, user_key, user_secret, endpoint = nil)
    endpoint ||= 'http://api.responder.co.il/v1.0'
    consumer = OAuth::Consumer.new(client_key, client_secret, site: endpoint)
    @access_token = OAuth::AccessToken.new(consumer, user_key, user_secret)
  end

  # <!----------- LISTS -----------!>

  # get all the lists
  #
  # Example:
  #   >> RavMeser.get_lists()
  #   => { "LISTS" => [{}, {}, ... ] }
  #
  def get_lists
    send_request(:get, '', '', [], {})
  end

  # get list by id
  #
  # Example:
  #   >> RavMeser.get_list(123456)
  #   => { "LISTS" => [{}, {}, ... ] }
  #
  # Arguments:
  #   id: (int)
  def get_list(id)
    send_request(:get, '', '?', ['list_ids', id.to_s], {})
  end

  # create new list
  #
  # Example:
  #   >> RavMeser.create_list( {"DESCRIPTION": "Test List", "NAME": "try", ... } )
  #   => {"ERRORS"=>[], "LIST_ID"=>123456, "INVALID_EMAIL_NOTIFY"=>[], "INVALID_LIST_IDS"=>[]}
  #
  # Arguments:
  #   args: (Hash)
  def create_list(args = {})
    send_request(:post, 'info', '', [], args)
  end

  # edit list by id
  #
  # Example:
  #   >> RavMeser.edit_list(123456, {"DESCRIPTION": "Test List Edited", "NAME": "try Edited", ... } )
  #   => {"ERRORS"=>[], "INVALID_EMAIL_NOTIFY"=>[], "INVALID_LIST_IDS"=>[], "SUCCESS"=>true}
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def edit_list(id, args = {})
    send_request(:put, 'info', '/' + id.to_s, [], args)
  end

  # delete list by id
  #
  # Example:
  #   >> RavMeser.delete_list(123456)
  #   => {"DELETED_LIST_ID"=>123456}
  #
  # Arguments:
  #   id: (int)
  def delete_list(id)
    send_request(:delete, 'info', '/' + id.to_s, [], {})
  end

  # <!----------- SUBSCRIBERS -----------!>

  # get subscribers from specific list
  #
  # Example:
  #   >> RavMeser.get_subscribers(123456)
  #   => [{}, {}, ... ]
  #
  # Arguments:
  #   id: (int)
  def get_subscribers(id)
    send_request(:get, '', '/' + id.to_s + '/subscribers', [], {})
  end

  # create new subscribers in specific list
  #
  # Example:
  #   >> RavMeser.create_subscribers(123456, {0 => {'EMAIL': "sub1@email.com", 'NAME': "sub1"}, 1 => {'EMAIL': "sub2@email.com", 'NAME': "sub2"}} )
  #   => {"SUBSCRIBERS_CREATED": [112233], "EMAILS_INVALID": [], "EMAILS_EXISTING": ["sub1@email.com"], "EMAILS_BANNED": [], "PHONES_INVALID": [], "PHONES_EXISTING": [], "BAD_PERSONAL_FIELDS": {}, "ERRORS" : [] }
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def create_subscribers(id, args = {})
    send_request(:post, 'subscribers', '/' + id.to_s + '/subscribers', [], args)
  end

  # edit subscribers of specific list
  #
  # Example:
  #   >> RavMeser.edit_subscribers(123456, {0 => {'IDENTIFIER': "sub1@email.com", 'NAME': "sub1NewName"}, 1 => {'IDENTIFIER': "sub2", 'NAME': "sub2"}} )
  #   => {"SUBSCRIBERS_UPDATED": [112233], "INVALID_SUBSCRIBER_IDENTIFIERS": ["sub1@email.com"], "EMAILS_INVALID": [], "EMAILS_EXISTED": [], "EMAILS_BANNED": [], "PHONES_INVALID": [], "PHONES_EXISTING": [], "BAD_PERSONAL_FIELDS": {} }
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def edit_subscribers(id, args)
    send_request(:put, 'subscribers', '/' + id.to_s + '/subscribers', [], args)
  end

  # delete subscribers of specific list
  #
  # Example:
  #   >> RavMeser.delete_subscribers(123456, {0 => { 'EMAIL': "sub8@email.com" }, 1 => { 'ID': 323715811 }} )
  #   => {"INVALID_SUBSCRIBER_IDS": [], "INVALID_SUBSCRIBER_EMAILS": [], "DELETED_SUBSCRIBERS": {} }
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def delete_subscribers(id, args)
    send_request(:post, 'subscribers', '/' + id.to_s + '/subscribers?', %w[method delete], args)
  end

  # create new subscribers in specific list and update subscribers that exists
  #
  # Example:
  #   >> RavMeser.upsert_subscribers(123456, {0 => {'EMAIL': "sub1@email.com", 'NAME': "sub1"}, 1 => {'EMAIL': "sub2@email.com", 'NAME': "sub2"}} )
  #   => [{"SUBSCRIBERS_CREATED": [112233], "EMAILS_INVALID": [], "EMAILS_EXISTING": ["sub1@email.com"], "EMAILS_BANNED": [], "PHONES_INVALID": [], "PHONES_EXISTING": [], "BAD_PERSONAL_FIELDS": {}, "ERRORS" : [] },
  #      {"SUBSCRIBERS_UPDATED": [223344], "INVALID_SUBSCRIBER_IDENTIFIERS": [], "EMAILS_INVALID": [], "EMAILS_EXISTED": [], "EMAILS_BANNED": [], "PHONES_INVALID": [], "PHONES_EXISTING": [], "BAD_PERSONAL_FIELDS": {} }]
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def upsert_subscribers(id, args = {})
    raise 'Too few subscribers' if args.length.zero?

    create_response = send_request(:post, 'subscribers', '/' + id.to_s + '/subscribers', [], args)
    raise "ERRORS: #{create_response['ERRORS']}" unless create_response['ERRORS'].empty?

    edit_response = {}
    unless create_response['EMAILS_EXISTING'].empty?
      update_args = {}
      create_response['EMAILS_EXISTING'].each_with_index do |email, index|
        update_args[index] = get_subscriber_args_and_set_identifier(args, email)
      end
      edit_response = send_request(:put, 'subscribers', '/' + id.to_s + '/subscribers', [], update_args)
    end

    [create_response, edit_response]
  end

  # create new subscriber in specific list - update the subscriber if already exists
  #
  # Example:
  #   >> RavMeser.upsert_subscriber(123456, {0 => {'EMAIL': "sub1@email.com", 'NAME': "sub1"} )
  #   => [{"SUBSCRIBERS_CREATED": [], "EMAILS_INVALID": [], "EMAILS_EXISTING": ["sub1@email.com"], "EMAILS_BANNED": [], "PHONES_INVALID": [], "PHONES_EXISTING": [], "BAD_PERSONAL_FIELDS": {}, "ERRORS" : [] },
  #      {"SUBSCRIBERS_UPDATED": [223344], "INVALID_SUBSCRIBER_IDENTIFIERS": [], "EMAILS_INVALID": [], "EMAILS_EXISTED": [], "EMAILS_BANNED": [], "PHONES_INVALID": [], "PHONES_EXISTING": [], "BAD_PERSONAL_FIELDS": {} }]
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def upsert_subscriber(id, args = {})
    raise 'Too many subscribers' unless args.length == 1

    edit_response = {}
    create_response = send_request(:post, 'subscribers', '/' + id.to_s + '/subscribers', [], args)
    raise "ERRORS: #{create_response['ERRORS']}" unless create_response['ERRORS'].empty?

    if create_response['EMAILS_EXISTING'].length == 1
      args[0][:IDENTIFIER] = args[0].delete(:EMAIL)
      edit_response = send_request(:put, 'subscribers', '/' + id.to_s + '/subscribers', [], args)
    end

    [create_response, edit_response]
  end

  # <!----------- PERSONAL FIELDS -----------!>

  # get personal fields from specific list
  #
  # Example:
  #   >> RavMeser.get_personal_fields(123456)
  #   => {"LIST_ID": 123456, "PERSONAL_FIELDS": [{"ID": 1234, "NAME": "City", "DEFAULT_VALUE": "Tel Aviv", "DIR": "rtl", "TYPE": 0}, {"ID": 5678, "NAME": "Birth Date", "DEFAULT_VALUE" : "", "DIR": "ltr", "TYPE": 1}] }
  #
  # Arguments:
  #   id: (int)
  def get_personal_fields(id)
    send_request(:get, '', '/' + id.to_s + '/personal_fields', [], {})
  end

  # create new personal fields in specific list
  #
  # Example:
  #   >> RavMeser.create_personal_fields(123456, {0 => {"NAME": "City", "DEFAULT_VALUE": "Tel Aviv", "DIR": "rtl", "TYPE": 0}, 1 => {"NAME": "Date of birth", "TYPE": 1}} )
  #   => {"LIST_ID": 123456, "CREATED_PERSONAL_FIELDS": [], "EXISTING_PERSONAL_FIELD_NAMES": []}
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def create_personal_fields(id, args = {})
    send_request(:post, 'personal_fields', '/' + id.to_s + '/personal_fields', [], args)
  end

  # edit personal fields of specific list
  #
  # Example:
  #   >> RavMeser.edit_personal_fields(123456, {0 => {"ID": "1234", "DEFAULT_VALUE": "Tel Aviv-Jaffa"}, 1 => {"ID": "5678", "DIR": "rtl"}})
  #   => {"LIST_ID" : 123456, "UPDATED_PERSONAL_FIELDS": [], "INVALID_PERSONAL_FIELD_IDS": [], "EXISTING_PERSONAL_FIELD_NAMES": []}
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def edit_personal_fields(id, args)
    send_request(:put, 'personal_fields', '/'  + id.to_s + '/personal_fields', [], args)
  end

  # delete personal fields of specific list
  #
  # Example:
  #   >> RavMeser.delete_personal_fields(123456, {0 => { 'ID': 1234 }, 1 => { 'ID': 5678 }} )
  #   => {"DELETED_FIELDS": [], "INVALID_FIELD_IDS" : [] }
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def delete_personal_fields(id, args)
    send_request(:post, 'personal_fields', '/' + id.to_s + '/personal_fields?', %w[method delete], args)
  end

  # create new message to specific list
  #
  # Example:
  #   >> RavMeser.create_message(123456, {'TYPE' => 1, 'BODY_TYPE' => 0, 'SUBJECT' => 'subject2', 'BODY' => 'message HTML body'} )
  #   => {"ERRORS"=>[], "MESSAGE_ID"=>3586177}
  #
  # Arguments:
  #   id: (int)
  #   args: (Hash)
  def create_message(id, args)
    send_request(:post, 'info', '/' + id.to_s + '/messages', [], args)
  end

  # send message of specific list
  #
  # Example:
  #   >> RavMeser.send_message(123456, 565656)
  #   => {"MESSAGE_SENT"=>true}
  #
  # Arguments:
  #   list_id: (int)
  #   msg_id: (int)
  def send_message(list_id, msg_id)
    send_request(:post, '', '/' + list_id.to_s + '/messages/' + msg_id.to_s , [], {} )
  end

  # create and send message of specific list
  #
  # Example:
  #   >> RavMeser.create_and_send_message(123456, {'TYPE' => 1, 'BODY_TYPE' => 0, 'SUBJECT' => 'subject2', 'BODY' => 'message HTML body'})
  #   => {"MESSAGE_SENT"=>true}
  #
  # Arguments:
  #   list_id: (int)
  #   args: (Hash)
  def create_and_send_message(id, msg)
    res = create_message(id, msg)
    send_message(id, res['MESSAGE_ID'])
  end


  def send_any_request(type, path, query='')
    path = '/' + path
    query = [query]
    path_request = query.empty? ? path : path + URI.encode_www_form(query)
    response = @access_token.request(type, path_request)

    begin
      response = JSON.parse(response.body)
    rescue StandardError => e
      if ENV['RAV_MESER_DEBUG']
        pp "Response was: ", response, response.body
      end
      raise e, response.body
    end
    response
  end

  private

  # private method
  # common code to send the requests
  #
  # Example:
  #   >> send_request(:get, 'info', '?list_ids=123456', {} )
  #   => {}
  #
  # Arguments:
  #   type: (:get \ :post \ :put \  :delete)
  #   object_name: (string) - ('info', 'subscribers', 'personal_fields')
  #   query: (string)
  #   args: (Hash)
  def send_request(type, object_name = '', path = '', query = [], args = {})
    unless args == {}
      json_obj = { object_name =>
        JSON.generate(args) }
    end

    path = '/lists' + path
    query = [query]
    path_request = query.empty? ? path : path + URI.encode_www_form(query)
    response = @access_token.request(type, path_request, json_obj)

    begin
      response = JSON.parse(response.body)
    rescue StandardError => e
      if ENV['RAV_MESER_DEBUG']
        pp "Response was: ", response, response.body
      end
      raise e, response.body
    end
    response
  end

  def get_subscriber_args_and_set_identifier(args, email)
    args.each do |_, v|
      if v[:EMAIL] == email
        v[:IDENTIFIER] = v.delete(:EMAIL)
        return v
      end
    end
  end
end
