module ChiliPDF
  module TokenManager
    extend self

    MAPPINGS = {:current_page => {
                   :replacement_object  => "[page]",
                   :description         => "The current page of the PDF document."},
                :total_pages => {
                   :replacement_object  => '[topage]',
                   :description         => "The total number of pages in the PDF document."},
                :datestamp => {
                   :replacement_object  => lambda {Time.now.strftime('%d-%b-%Y')},
                   :description         => "The current date in the format of DD-MON-YYYY'"},
                :current_quarter => {
                   :replacement_object => lambda {calculate_quarter.to_s},
                   :description        => "The current fiscal quarter (assuming Jan-Mar is thefirst quarter). Example output: '1'."},
                :current_year => {
                   :replacement_object => lambda {Time.now.strftime('%Y')},
                   :description        => "The current year in YYYY-format"}}

    def tokens
      raw_tokens.map {|matcher, meta|
        StringToken.new(matcher, meta[:replacement_object], meta[:description])
      }
    end

    def add_token_definition
      raw_tokens.merge!(yield)
    end

    def apply_tokens_to(string)
      tokens.inject(string.dup) {|modified, token| modified = token.apply_to modified}
    end

    private
      def raw_tokens
        @raw_tokens ||= MAPPINGS.dup
      end

      def self.calculate_quarter
        month = Time.now.strftime('%m').to_i
        ((month - 1) / 3) + 1
      end
  end
end
