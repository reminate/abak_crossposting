module AbakCrossposting
  module Facebook
    class Publisher
      require 'ostruct'

      attr_reader :post, :group

      def initialize(post, group)
        @post  = Post.new post
        @group = Group.new group
      end

      def run
        response = api.send(post.posting_method, post.content, post.options, group.id)
        parse_post_id response
      end

    private

      def api
        @api ||= Koala::Facebook::API.new(group.access_token)
      end

      def parse_post_id response
        post.has_picture? ? response["post_id"] : response["id"]
      end

      class Group < OpenStruct
      end

      class Post < Base::Post

        def posting_method
          has_picture? ? :put_picture : :put_wall_post
        end

        def content
          has_picture? ? picture : message
        end

        def options
          if has_picture? && has_message?
            { message: message }
          elsif has_link?
            { link: link }
          else
            {}
          end
        end
      end

    end
  end
end