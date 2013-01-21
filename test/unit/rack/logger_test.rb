require 'test_helper'
require 'stringio'

module Librato
  class Rack
    class LoggerTest < MiniTest::Unit::TestCase

      def setup
        @buffer = StringIO.new
        log_object = ::Logger.new(@buffer) # stdlib logger
        @logger = Logger.new(log_object) # rack logger
      end

      def test_log_levels
        assert_equal :info, @logger.log_level, 'should default to info'

        @logger.log_level = :debug
        assert_equal :debug, @logger.log_level, 'should accept symbols'

        @logger.log_level = 'trace'
        assert_equal :trace, @logger.log_level, 'should accept strings'

        assert_raises(InvalidLogLevel) { @logger.log_level = :foo }
      end

      def test_simple_logging
        @logger.log_level = :info

        # logging at log level
        @logger.log :info, 'a log message'
        @buffer.rewind
        lines = @buffer.readlines
        assert_equal 1, buffer_lines.length, 'should have added a line'
        assert buffer_lines[0].index('a log message'), 'should log message'

        # logging above level
        @logger.log :error, 'an error message'
        assert_equal 2, buffer_lines.length, 'should have added a line'
        assert buffer_lines[1].index('an error message'), 'should log message'

        # logging below level
        @logger.log :debug, 'a debug message'
        assert_equal 2, buffer_lines.length, 'should not have added a line'
      end

      private

      def buffer_lines
        @buffer.rewind
        @buffer.readlines
      end

    end
  end
end