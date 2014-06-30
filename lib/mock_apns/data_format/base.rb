module MockAPNS
  module DataFormat
    class Base
      attr_reader :data
      attr_reader :command

      def initialize(data)
        @data = data
      end
    end
  end
end
