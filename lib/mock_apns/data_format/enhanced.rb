module MockAPNS
  module DataFormat
    require_relative 'base'

    class Enhanced < Base
      attr_reader :identifier
      attr_reader :expiry
      attr_reader :token_length
      attr_reader :token
      attr_reader :payload_length
      attr_reader :payload

      def initialize(data)
        super(data)
        @command = 1
        parse
      end

      # See https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/LegacyFormat.html
      def parse
        command = data.byteslice(0).unpack('C').first
        if (command != @command)
          #TODO
        end

        @identifier = @data.byteslice(1, 4).unpack('N1')
        @expiry = @data.byteslice(5, 4).unpack('N1').first
        @token_length = @data.byteslice(9, 2).unpack('n1').first
        @token = @data.byteslice(11, @token_length).unpack('H*').first
        @payload_length = @data.byteslice(11 + @token_length, 2).unpack('n1').first
        @payload = @data.byteslice(13 + @token_length, @payload_length);
      end

      def to_hash
        return {
          command: @command,
          identifier: @identifier,
          expiry: @expiry,
          token_length: @token_length,
          token: @token,
          payload_length: @payload_length,
          payload: @payload,
        }
      end
    end
  end
end
