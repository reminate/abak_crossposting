# coding: utf-8
require 'spec_helper'
require 'abak_crossposting/vkontakte/publisher'

describe AbakCrossposting::Vkontakte::Publisher do
  describe "#run" do
    let(:group)     { {:id => 1, :access_token => 'KnockKnock'} }
    let(:publisher) { AbakCrossposting::Vkontakte::Publisher.new(post, group) }
    let(:api)       { publisher.send(:api).wall }

    let(:message)   { 'Cowabunga' }
    let(:link)      { 'http://www.tmnt.com/' }
    let(:picture)   { '/home/leonardo/plan.jpg' }

    let(:response)  { Hashie::Mash.new(:post_id => 1) }

    # stub namespace creation
    before { VkontakteApi::Client.any_instance.stub(:method_missing).with(:wall).and_return(true) }
    before { VkontakteApi::Client.any_instance.stub(:method_missing).with(:photos).and_return(true) }

    context "when there is post with message only" do
      let(:post) { {:message => message} }

      it "should call post method with message param only" do
        api.should_receive(:method_missing).
            with(:post, {:message => message, :attachments => [], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

        publisher.run
      end
    end

    context "when there is post with link only" do
      let(:post) { {:link => link} }

      it "should call post method with link param only" do
        api.should_receive(:method_missing).
            with(:post, {:message => nil, :attachments => [link], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

        publisher.run
      end
    end

    context "when there is post with link and message" do
      let(:post) { {:message => message, :link => link} }

      it "should call post method with message and link params" do
        api.should_receive(:method_missing).
            with(:post, {:message => message, :attachments => [link], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

        publisher.run
      end

    end

    context "when post with blank fields" do
      let(:post) { Hash.new }

      it "should call post method without message and attachments params" do
        api.should_receive(:method_missing).
            with(:post, {:message => nil, :attachments => [], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

        publisher.run
      end
    end

    context "when there is post with picture" do
      def should_upload_picture
        picture_id = [Hashie::Mash.new(:id => "photo1_1")]
        upload_url = Hashie::Mash.new(:upload_url => link)

        # get upload url
        api.should_receive(:method_missing).
            with(:get_wall_upload_server, { :gid => 1 }).
            and_return(upload_url)

        # upload picture
        VkontakteApi.should_receive(:upload).
            with({:url => link, :photo => [picture, "image/jpeg"]}).
            and_return(upload_response)

        # save picture
        api.should_receive(:method_missing).
            with(:save_wall_photo, upload_response.merge(:gid => 1)).
            and_return(picture_id)
      end

      let(:upload_response) { Hashie::Mash.new(:server => 1, :photos => [], :hash => 'hASh') }
      let(:post) { {:picture => picture} }

      it "should call post method with picture param only" do
        should_upload_picture

        api.should_receive(:method_missing).
            with(:post, {:message => nil, :attachments => ["photo1_1"], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

        publisher.run
      end

      context "and with message" do
        let(:post) { {:picture => picture, :message => message} }

        it "should call post method with picture and message params" do
          should_upload_picture

          api.should_receive(:method_missing).
            with(:post, {:message => message, :attachments => ["photo1_1"], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

          publisher.run
        end
      end

      context "and with link" do
        let(:post) { {:picture => picture, :link => link} }

        it "should call post method with picture and link params" do
          should_upload_picture

          api.should_receive(:method_missing).
            with(:post, {:message => nil, :attachments => ["photo1_1", link], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

          publisher.run
        end

      end

      context "and with link and message" do
        let(:post) { {:message => message, :picture => picture, :link => link} }

        it "should call post method with picture and link params" do
          should_upload_picture

          api.should_receive(:method_missing).
            with(:post, {:message => message, :attachments => ["photo1_1", link], :owner_id => -group[:id], :from_group => true}).
            and_return(response)

          publisher.run
        end

      end
    end
  end

end