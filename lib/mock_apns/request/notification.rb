module MockAPNS
  module Request
    class Notification
      attr_reader :body
      attr_reader :pretty_body

      def initialize(data)
        @body = data
        parse_body
      end

      private
      def parse_body
        command = @body.byteslice(0).unpack('C').first
        case command
        when 0
          formatted_data = DataFormat::Simple.new(@body)
        when 1
          formatted_data = DataFormat::Enhanced.new(@body)
        when 2
          # TODO
          # Modern format
        end

        @pretty_body = formatted_data.to_hash
      end
    end
  end
end
