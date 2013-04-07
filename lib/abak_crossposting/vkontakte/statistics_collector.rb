module AbakCrossposting
  module Vkontakte
    class StatisticsCollector
      class << self
        # Get likes, comments and reposts count for the given post
        #
        # Usage
        #   AbakCrossposting::Vkontakte::StatisticCollector.get_stats("-1020383_5", "ASEWawFADaAsasdHsaytrsrTAZD")
        #    # => {:likes_count => 3, :comments_count => 1, :reposts_count => 0}
        #
        # @param [String] post_id Vkontakte ID of the post
        # @param [String] access_token Vkontakte access_token
        def get_stats(post_id, access_token)
          api = ::VkontakteApi::Client.new(access_token)

          data = api.wall.get_by_id(posts: post_id)
          stats_info(data)
        end

        private
        def stats_info(data)
          {likes_count: data.likes[:count], comments_count: data.comments[:count], reposts_count: data.reposts[:count]}
        end
      end
    end
  end
end
