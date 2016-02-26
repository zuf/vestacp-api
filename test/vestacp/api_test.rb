require 'test_helper'

class Vestacp::ApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Vestacp::Api::VERSION
  end

  def test_that_it_should_return_accounts_info
    stub_request(:post, "http://example.com/api/").with(:body => "abc", :headers => { 'Content-Length' => 3 })


    client = ::Vestacp::Api::Client.new host: 'example.com', user: ENV[:user], password: ENV[:password], use_ssl: false, account: 'admin'
    domain = ENV[:domain]
    forwards = client.list_mail_accounts domain

    assert forwards.size > 1

  end
end
