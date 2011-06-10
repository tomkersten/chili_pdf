module ChiliPDF
  # Associates documentation of a "string to replace" (matcher) with it's
  # "replacement text" (replacement_object) and allows either either static
  # or dynamic string replacement declarations.
  class StringToken
    # Description used if the default description is empty
    DEFAULT_DESCRIPTION = "[No description provided]"

    # String used to denote the begining of a token
    STARTING_DELIMITER = "{{"

    # String used to denote the ending of a token
    ENDING_DELIMITER   = "}}"

    # Public: Get the matcher of the token
    # Returns the String matcher of token
    attr_reader :matcher

    # Returns the String replacement_object of token
    attr_reader :replacement_object

    # Returns the String description of the token
    attr_reader :description


    # Public: Create new instance of StringToken class
    #
    # matcher            - the #to_s value to search for
    # replacement_object - the value to replace 'matcher' with
    # description        - a friendly description which can be used
    #                       to explain what purpose the matcher is
    #                       intended to serve
    #
    # 'replacement_object' may be any object, but special behavior
    # exists if the value is a Proc object. Refer to the #apply_to
    # documentation for details on said behavior.
    #
    # Returns new instance of StringToken
    def initialize(matcher, replacement_object, description = nil)
      @matcher = matcher
      @replacement_object = replacement_object
      @description = description.blank? ? DEFAULT_DESCRIPTION : description
    end

    # Public: Substitutes any occurrences of #replacement_object in the specified
    #         object's response to #to_s. If #replacement_object returns a Proc
    #         object, #call will be issued to it.
    #
    # string - string to search for token occurrences in
    #
    # Examples:
    # Returns copy of string with matcher text occurrences replaced.
    def apply_to(string)
      string.gsub(replacement_regexp(string), replacement_value.to_s)
    end

    def matcher_with_delimiters
      "#{STARTING_DELIMITER}#{matcher}#{ENDING_DELIMITER}"
    end
    private
      def replacement_regexp(string)
        Regexp.new(/#{escaped(STARTING_DELIMITER)}#{matcher.to_s}#{escaped(ENDING_DELIMITER)}/)
      end

      def replacement_value
        replacement_object.is_a?(Proc) ? replacement_object.call(self) : replacement_object
      end

      def escaped(string)
        Regexp.escape string
      end
  end
end
