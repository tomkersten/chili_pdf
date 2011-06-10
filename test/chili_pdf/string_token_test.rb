require 'test_helper'

class StringTokenTest < Test::Unit::TestCase
  context ".apply_to" do
    setup do
      @sdelim = StringToken::STARTING_DELIMITER
      @edelim = StringToken::ENDING_DELIMITER
      @matcher = "matcher_here"
      @replacement_object = 'text_added'
      @token = StringToken.new(@matcher, @replacement_object)
    end

    should "returns does not modify the original string passed in" do
      original = '{{test}}'
      string = original.dup
      assert_not_equal original.object_id, @token.apply_to(string).object_id
    end

    should "set a default value for a description when not provided" do
      assert_equal StringToken::DEFAULT_DESCRIPTION, @token.description
    end

    context "when the token's matcher does not exist in the specified string" do
      should "return the same string value" do
        assert_equal 'string', @token.apply_to('string')
      end
    end

    context "when the token's matcher does exist in the specified string" do
      setup do
        @string = "This does have the matcher twice '#{@sdelim}#{@matcher}#{@edelim}' '#{@sdelim}#{@matcher}#{@edelim}'"
      end

      should "return a string value with only the matcher text replaced" do
        expected_string = "This does have the matcher twice '#{@replacement_object}' '#{@replacement_object}'"
        assert_equal expected_string, @token.apply_to(@string)
      end

      context "and the replacement object is a Proc object" do
        setup do
          @string = "This does have the matcher twice '#{@sdelim}#{@matcher}#{@edelim}' '#{@sdelim}#{@matcher}#{@edelim}'"
          @result = 'resulting_replaced_text'
          faker_class = Struct.new("Faker", :name)
          faker = faker_class.new(@result)

          @replacement_object = lambda {faker.name}
        end

        should "return a string value with the result of calling the Proc and passing 'self' as an argument" do
          token = StringToken.new(@matcher, @replacement_object)

          expected_string = "This does have the matcher twice '#{@result}' '#{@result}'"
          assert_equal expected_string, token.apply_to(@string)
        end
      end
    end
  end
end
