module AbakCrossposting
  module Vkontakte
    # Posting to Vkontakte public group wall
    #
    # Usage
    #   post = { :message => 'Hello, Vkontakte!', :link => 'http://my_home_page.html' }
    #   group = { :id => 123, :access_token => 'aCCEssToKEN' }
    #   publisher = AbakCrossposting::Vkontakte::Publisher.new post, group
    #   publisher.run
    class Publisher
      require 'ostruct'
      require 'vkontakte_api'
      require 'abak_crossposting/base/post'

      attr_reader :group, :post

      # @param [Hash] post  Content for posting (message, link, picture)
      # @param [Hash] group Vkontakte group details (id, token)
      def initialize(post, group)
        @post  = Base::Post.new post
        @group = Group.new group
      end

      def run
        response = api.wall.post message:     post.message,
                                 attachments: attachments,
                                 owner_id:    "-#{group.id}",
                                 from_group:  true

        parse_post_id response
      rescue ::VkontakteApi::Error
        raise APIError.new($!.message)
      end

      private

      class Group < OpenStruct; end

      def api
        @api ||= ::VkontakteApi::Client.new(group.access_token)
      end

      def attachments
        [].tap { |a| 
          a << picture_id if post.has_picture?
          a << post.link  if post.has_link? 
        }
      end

      def picture_id
        response = upload_picture
        response = save_uploaded_picture response
        response.first.id
      end

      def get_upload_url
        api.photos.get_wall_upload_server(gid: group.id).upload_url
      end

      def upload_picture
        VkontakteApi.upload(url: get_upload_url, photo: [post.picture, post.picture_content_type])
      end

      def save_uploaded_picture(args)
        api.photos.save_wall_photo(args.merge gid: group.id)
      end

      def parse_post_id(response)
        "-#{group.id}_#{response.post_id}"
      end

    end
  end
end
