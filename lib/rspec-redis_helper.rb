require "rspec-redis_helper/version"

module RSpec
  module RedisHelper

    TEST = { url: "redis://127.0.0.1:6379/1" }

    def redis
      @redis ||= ::Redis.connect(TEST)
    end

    def other
      @other ||= ::Redis.connect(TEST)
    end

    def with_watch( redis, *args )
      redis.watch( *args )
      begin
        yield
      ensure
        redis.unwatch
      end
    end

    def with_clean_redis(&block)
      redis.client.disconnect # auto connect after fork
      other.client.disconnect # auto connect after fork
      redis.flushall          # clean before run
      begin
        yield
      ensure
        redis.flushall        # clean up after run
        redis.quit            # quit (close) connection
        other.quit            # quit (close) connection
      end
    end

  end
end
