module AbakCrossposting
  module Facebook
    class OAuth
      attr_reader :oauth

      def initialize(app_id, app_secret, callback_url)
        @oauth = ::Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
      end

      def url_for_oauth_code
        oauth.url_for_oauth_code(:permissions => permissions, :display => "touch")
      end

      def get_access_token(oauth_code)
        oauth.get_access_token(oauth_code)
      end

      def exchange_access_token(access_token)
        oauth.exchange_access_token(access_token)
      end

      private
      def permissions
        ["publish_actions", "photo_upload", "video_upload", "publish_stream", "read_stream", "manage_pages"]
      end
    end
  end
end