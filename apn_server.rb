require 'eventmachine'
require './lib/mock_apns'

module ApnServer
  def post_init
    puts "-- someone connected to the apn server!"
    # TODO add ssl certification file settings to Config
    start_tls(:private_key_file => '/usr/local/ssl/private/sslkey.pem', :cert_chain_file => '/usr/local/ssl/certs/sslcert.pem', :verify_peer => false)
  end

  def receive_data data
    request = MockAPNS::Request::Notification.new(data)
    puts "Request: #{request.pretty_body}"

    expect = MockAPNS::Expectation.new
    if expect.is_response
      response_data = expect.response.to_binary
      send_data(response_data)
      puts "Response: #{expect.response.to_h.inspect}"
      puts "Response(binary): #{response_data.inspect}"
    end

    if expect.is_disconnection
      puts "Close connection"
      close_connection
    end

    puts "No response"
  end

  def unbind
    puts "-- someone disconnected from the apn server!"
  end
end

EventMachine.run {
  EventMachine.start_server "127.0.0.1", 2195, ApnServer
}
