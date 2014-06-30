module MockAPNS
  module Response
    class Error
      attr_accessor :command
      attr_reader :status
      attr_reader :identifier

      def initialize(status, identifier = '')
        @command = 8
        @status = status || 0
        @identifier = identifier
      end

      def to_binary
        [@command, @status, @identifier].pack('CCa4')
      end

      def to_h
        {command: @command, status: @status, identifier: @identifier}
      end
    end
  end
end
