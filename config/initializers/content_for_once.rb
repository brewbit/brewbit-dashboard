module ActionView
  module Helpers
    module CaptureHelper
      def content_once_for(name, key = nil, &block)
        @__content_once_map ||= {}
        @__content_once_map[name] ||= {}
        if key.nil?
          /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller[0]
          key = "#{$1}#{$2}".to_s
        end
        unless @__content_once_map[name].key? key
          content_for(name, &block)
          @__content_once_map[name][key] = true
        end
        nil
      end
      alias :content_for_once :content_once_for
    end
  end
end