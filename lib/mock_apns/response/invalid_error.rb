module MockAPNS
  module Response
    class InvalidError
      attr_reader :body

      def initialize(body)
        @body = body
      end

      def to_binary
        [@body].pack('a*') if @body # invalid error body
      end

      def to_h
        {body: @body}
      end
    end
  end
end
