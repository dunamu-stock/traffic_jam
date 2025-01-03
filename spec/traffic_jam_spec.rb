require_relative 'spec_helper'

describe TrafficJam do
  include RedisHelper

  TrafficJam.configure do |config|
    config.redis = RedisHelper.redis
    config.register(:test, 3, 60)
    config.register(:test4, 4, 60)
  end

  let(:_value) { "user1" }

  describe '::limit' do
    it "should return limit instance with registered limits" do
      limit = TrafficJam.limit(:test, _value)
      assert_equal :test, limit.action
      assert_equal _value, limit.value
      assert_equal 3, limit.max
      assert_equal 60, limit.period
    end

    it "should raise error if not found" do
      assert_raises(TrafficJam::LimitNotFound) do
        TrafficJam.limit(:test2, _value)
      end
    end
  end

  describe '::reset_all' do
    it "should reset all rate limits" do
      limit = TrafficJam.increment!(:test, _value)
      limit = TrafficJam.increment!(:test4, _value)
      assert_equal 1, TrafficJam.used(:test, _value)
      assert_equal 1, TrafficJam.used(:test4, _value)

      TrafficJam.reset_all
      assert_equal 0, TrafficJam.used(:test, _value)
      assert_equal 0, TrafficJam.used(:test4, _value)
    end

    it "should reset all rate limits for one action" do
      limit = TrafficJam.increment!(:test, _value)
      limit = TrafficJam.increment!(:test4, _value)
      assert_equal 1, TrafficJam.used(:test, _value)
      assert_equal 1, TrafficJam.used(:test4, _value)

      TrafficJam.reset_all(action: :test)
      assert_equal 0, TrafficJam.used(:test, _value)
      assert_equal 1, TrafficJam.used(:test4, _value)
    end
  end

  describe 'class helpers' do
    before { TrafficJam.config.register(:test, 3, 60) }
    let(:_value) { "user1" }

    it "should call methods with registered limits" do
      TrafficJam.increment(:test, _value, 1)
      assert_equal 1, TrafficJam.used(:test, _value)
    end

    it "should raise error if limit not found" do
      assert_raises(TrafficJam::LimitNotFound) do
        TrafficJam.increment(:test2, _value, 1)
      end
    end
  end
end
