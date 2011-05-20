module UserPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :allowed_to?, :extended_wiki_filter
    end
  end

  module InstanceMethods
    # Fakes authorizing a request to the original WikiController to inherit
    # the permissions set on it, instead of keeping two sets of permissions
    # for PDF export of a wiki page and viewing the HTML version.
    def allowed_to_with_extended_wiki_filter?(action, context, options={})
      if making_extended_wiki_request?(action)
        allowed_to_without_extended_wiki_filter?(masqueraded_wiki_show_request(action), context, options)
      else
        allowed_to_without_extended_wiki_filter?(action, context, options)
      end
    end

    private
      def masqueraded_wiki_show_request(action)
        case action
        when :export_wiki_pages then :view_wiki_pages
        when Hash
          if action[:controller] == 'extended_wiki'
            {:action => action[:action], :controller => 'wiki'}
          else
            action
          end
        else # not sure how to handle this action...just return the original
          action
        end
      end

      def making_extended_wiki_request?(action)
        case action
        when Symbol
          action == :export_wiki_pages
        when Hash
          'extended_wiki' == action[:controller]
        else
          false
        end
      end
  end
end
