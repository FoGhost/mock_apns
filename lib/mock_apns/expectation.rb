module MockAPNS
  # A simple expectation implementation by using tmp file for Unit test
  #
  # Format of expectation json file
  #  - success: []
  #  - error:
  #     * no error: {"type":"error","body":{"status":0}}
  #     * processing error: {"type":"error","body":{"status":1}}
  #     * missing device_token: {"type":"error","body":{"status":2}}
  #     * missing topic: {"type":"error","body":{"status":3}}
  #     * missing payload: {"type":"error","body":{"status":4}}
  #     * invalid token size: {"type":"error","body":{"status":5}}
  #     * invalid topic size: {"type":"error","body":{"status":6}}
  #     * invalid payload size: {"type":"error","body":{"status":7}}
  #     * invalid token: {"type":"error","body":{"status":8}}
  #     * shutdown: {"type":"error","body":{"status":10}}
  #     * none(unknown: {"type":"error","body":{"status":255}}
  #  - unkown error report:  {"type":"error","body":{"command":99,"status":0}}
  #  - disconnection (suddenly disconnected from server) : {"type":"disconnection"}
  class Expectation
    attr_reader :response
    attr_reader :interrupt

    def initialize
      path = '/tmp/mock_apn_expectation.json'
      if File.exist?(path)
        file = File.read(path)
        parse(JSON.parse(file))
      end
    end

    def is_response
      @response ? true : false
    end

    def is_disconnection
      @disconnection ? true : false
    end

    def parse(expected_hash)
      return nil unless expected_hash.is_a?(Hash)

      case expected_hash['type']
      when 'error'
        body = expected_hash['body']
        error = Response::Error.new(body['status'], body['identifier'])
        if body['command']
          error.command = body['command']
        end
        @response = error
      when 'invalid_error'
        @response = Response::InvalidError.new(expected_hash['body'])
      when 'disconnection'
        @disconnection = true
      end
    end
  end
end
