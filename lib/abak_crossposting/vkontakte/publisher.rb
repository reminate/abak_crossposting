module AbakCrossposting
  module Vkontakte
    class Publisher
      require 'ostruct'

      attr_reader :group, :post

      def initialize(post, group)
        @post  = Base::Post.new post
        @group = Group.new group
      end

      def run
        response = api.wall.post message:     post.message,
                                 attachments: attachments,
                                 owner_id:    -group.id,
                                 from_group:  true

        parse_post_id response
      end

    private

      def api
        @api ||= VkontakteApi::Client.new(group.access_token)
      end

      def attachments
        attachments = []
        attachments << picture_id if post.has_picture?
        attachments << post.link  if post.has_link?
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

      class Group < OpenStruct; end

    end
  end
end