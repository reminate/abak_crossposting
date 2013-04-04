module AbakCrossposting
  module Vkontakte
    class OAuth
      def initialize(app_id, app_secret, callback_url)
        ::VkontakteApi.configure do |config|
          config.app_id       = app_id
          config.app_secret   = app_secret
          config.redirect_uri = callback_url
        end
      end

      def url_for_oauth_code
        ::VkontakteApi.authorization_url(:type => :site, :scope => permissions)
      end

      def get_access_token(oauth_code)
        ::VkontakteApi.authorize(:code => oauth_code).token
      end

      private
      def permissions
        [:photos, :audio, :video, :wall, :offline, :stats]
      end
    end
  end
end