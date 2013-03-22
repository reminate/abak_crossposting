module AbakCrossposting
  module Vkontakte
    class StatisticsCollector
      class << self
        # Get likes, comments and reposts count for the given post
        #
        # Usage
        #   AbakCrossposting::Vkontakte::StatisticCollector.get_stats("-1020383_5", "ASEWawFADaAsasdHsaytrsrTAZD")
        #    # => {:likes => 3, :comments => 1, :reposts => 0}
        #
        # @param [String] post_id Vkontakte ID of the post
        # @param [String] access_token Vkontakte access_token
        def get_stats(post_id, access_token)
          api = ::VkontakteApi::Client.new(access_token)

          data = api.wall.get_by_id(post_id)
          stats_info(data)
        end

        private
        def stats_info(data)
          {likes: data.likes[:count], comments: data.comments[:count], reposts: data.reposts[:count]}
        end
      end
    end
  end
end