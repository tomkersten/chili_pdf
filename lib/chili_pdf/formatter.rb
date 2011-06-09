module ChiliPDF
  module Formatter
    extend self

    HEADER_FOOTER_FONT_SIZE = 8
    DEFAULT_MARGIN = '0.5in'
    DEFAULT_PAGE_SIZE = "Letter"
    DEFAULT_PAGE_TITLE = "Untitled"
    DEFAULT_LAYOUT = 'pdf.pdf.erb'
    DEFAULT_VIEW_TEMPLATE  = 'extended_wiki/show.pdf.html.erb'
    DYNAMIC_TOKEN_MAPPINGS = {:current_page => '[page]',
                              :total_pages => '[topage]',
                              :datestamp => lambda {Time.now.strftime('%d-%b-%Y')},
                              :current_quarter  => lambda {calculate_quarter.to_s},
                              :current_year     => lambda {Time.now.strftime('%Y')},
                              :page_title       => lambda {@page_title || DEFAULT_PAGE_TITLE}
                             }

    def render_options(filename, page_title = nil)
      # set @page_title instance variable so #replace_tokens_in can access it
      @page_title = page_title

      default_options = {
        :pdf => filename,
        :template => view_template,
        :page_size => DEFAULT_PAGE_SIZE,
        :margin => {
          :top    => DEFAULT_MARGIN,
          :bottom => DEFAULT_MARGIN,
          :left   => DEFAULT_MARGIN,
          :right  => DEFAULT_MARGIN
        },
        :layout => DEFAULT_LAYOUT
      }

      default_options.merge!(footer_options) if ChiliPDF::Config.footer_enabled?
      default_options.merge!(header_options) if ChiliPDF::Config.header_enabled?
      default_options
    end

    private
      def footer_options
        {:footer => {
          :font_size => 8,
          :line => true,
          :spacing => 2
        }.merge(substitute_tokens(ChiliPDF::Config.footer_values))}
      end

      def header_options
        {:header => {
          :font_size => HEADER_FOOTER_FONT_SIZE,
          :line => true,
          :spacing => 2
        }.merge(substitute_tokens(ChiliPDF::Config.header_values))}
      end

      def substitute_tokens(hash)
        hash.inject({}) do |converted_list, unconverted_item|
          key,value = unconverted_item
          converted_list.merge({key => replace_tokens_in(value)})
        end
      end

      def replace_tokens_in(string)
        cloned_string = string.dup
        DYNAMIC_TOKEN_MAPPINGS.each do |dynamic_token, rep_content|
          replacement_text = rep_content.is_a?(Proc) ? rep_content.call : rep_content
          cloned_string.gsub!(/\{\{#{dynamic_token.to_s}\}\}/, replacement_text)
        end
        cloned_string
      end

      def calculate_quarter
        month = Time.now.strftime('%m').to_i
        ((month - 1) / 3) + 1
      end

      def view_template
        DEFAULT_VIEW_TEMPLATE
      end
  end
end
