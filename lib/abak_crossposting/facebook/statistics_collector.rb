module AbakCrossposting
  module Facebook
    class StatisticsCollector
      class << self
        # Get likes, comments and reposts count for the given post
        #
        # Usage
        #   AbakCrossposting::Facebook::StatisticCollector.get_stats("10203831233_535632366321", "ASEWawFADaAsasdHsaytrsrTAZD")
        #    # => {:likes => 3, :comments => 1, :reposts => 0}
        #
        # @param [String] post_id Facebook ID of the post
        # @param [String] access_token Facebook access_token
        def get_stats(post_id, access_token)
          api = ::Koala::Facebook::API.new(access_token)

          data = api.fql_query("SELECT likes, comments, share_count FROM stream WHERE id = '#{post_id}'")
          stats_info(data.first)
        end

        private
        def stats_info(data)
          {likes: data["likes"]["count"], comments: data["comments"]["count"], reposts: data["share_count"]}
        end
      end
    end
  end
end