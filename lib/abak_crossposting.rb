require "abak_crossposting/version"
require "abak_crossposting/vkontakte/publisher"
require "abak_crossposting/facebook/publisher"
require "abak_crossposting/vkontakte/statistics_collector"
require "abak_crossposting/facebook/statistics_collector"

module AbakCrossposting
  class APIError < StandardError; end
end
