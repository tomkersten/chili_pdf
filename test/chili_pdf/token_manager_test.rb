require 'test_helper'

class TokenManagerTest < Test::Unit::TestCase
  context ".tokens" do
    should "return list of objects which respond to #apply_to" do
      assert TokenManager.tokens.first.respond_to?(:apply_to)
    end
  end
end
