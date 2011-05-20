module ApplicationControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :authorize, :extended_wiki_filter
    end
  end

  module InstanceMethods
    # Fakes authorizing a request to the original WikiController to inherit
    # the permissions set on it, instead of keeping two sets of permissions
    # for PDF export of a wiki page and viewing the HTML version.
    def authorize_with_extended_wiki_filter(ctrl = params[:controller], action = params[:action], global = false)
      if pdfable_extended_wiki_request?(ctrl, action)
        authorize_without_extended_wiki_filter('wiki', action, global)
      else
        authorize_without_extended_wiki_filter(ctrl, action, global)
      end
    end

    private
      def pdfable_extended_wiki_request?(ctrl, action)
        return ctrl == 'extended_wiki' && action == 'show'
      end
  end
end
