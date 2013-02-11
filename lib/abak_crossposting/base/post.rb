module AbakCrossposting
  module Base
    require 'ostruct'

    class Post < OpenStruct

      def has_message?
        !! message
      end

      def has_link?
        !! link
      end

      def has_picture?
        !! picture
      end

      def picture_content_type
        MIME::Types.type_for(picture).first.try(:content_type)
      end

    end

  end
end