# -*- encoding: utf-8 -*-
require "helper"

describe Redis, redis: true, redis_configuration: true do

  it "should be redis" do
    redis.should be_kind_of(Redis)
  end

  it "has sorted sets" do
    redis.zcard("it").should eq(0)
    redis.zadd("it", 2, "bar")
    redis.zadd("it", 3, "goo")
    redis.zcard("it").should eq(2)
    redis.zrange("it", 0, 0).should eq(["bar"]) # 0th item = smallest item
    redis.zrangebyscore( "it", 0, 1, limit: [0,1] ).should eq([])
    redis.zrangebyscore( "it", 0, 2, limit: [0,1] ).should eq(["bar"])
  end

  it "can select by score" do
    redis.zadd "it", 1, "a"
    redis.zadd "it", 2, "b"
    redis.zadd "it", 3, "c"
    redis.zadd "it", 4, "d"
    # inclusive by default http://redis.io/commands/zrangebyscore
    redis.zrangebyscore( "it", "-inf", 2 ).should eq(["a","b"])
    redis.zrangebyscore( "it", "-inf", 2, limit: [0,1] ).should eq(["a"])
  end

end
