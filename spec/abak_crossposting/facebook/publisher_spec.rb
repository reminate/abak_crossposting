# coding: utf-8
require 'spec_helper'
require 'abak_crossposting/facebook/publisher'

describe AbakCrossposting::Facebook::Publisher do

  describe "#run" do
    let(:group)     { {:id => 1, :access_token => 'KnockKnock'} }
    let(:publisher) { AbakCrossposting::Facebook::Publisher.new(post, group) }
    let(:api)       { publisher.send(:api) }
    let(:message)   { 'Cowabunga' }
    let(:link)      { 'http://www.tmnt.com/' }
    let(:picture)   { '/home/leonardo/plan.jpg' }
    let(:response)  { {"id" => 1} }

    context "when there is post with message only" do

      let(:post) { {:message => message} }

      it "should call put_wall_post method with message param only" do
        api.should_receive(:put_wall_post).
            with(message, {}, group[:id]).
            and_return(response)
        publisher.run
      end
    end

    context "when there is post with link only" do
      let(:post) { {:link => link} }

      it "should call put_wall_post method with link param only" do
        api.should_receive(:put_wall_post).
            with(nil, post, group[:id]).
            and_return(response)
        publisher.run
      end
    end

    context "when post with picture only" do
      let(:post) { {:picture => picture} }

      it "should call put_picture method with picture param only" do
        api.should_receive(:put_picture).
            with(picture, {}, group[:id]).
            and_return(response)
        publisher.run
      end
    end

    context "when post with message and link" do
      let(:post) { {:message => message, :link => link} }

      it "should call put_wall_post method with message and link params" do
        api.should_receive(:put_wall_post).
            with(message, { :link => link }, group[:id]).
            and_return(response)
        publisher.run
      end
    end

    context "when post with message and picture" do
      let(:post) { {:picture => picture , :message => message} }

      it "should call put_picture method with message and picture params" do
        api.should_receive(:put_picture).
            with(picture, {:message => message}, group[:id]).
            and_return(response)
        publisher.run
      end
    end

    context "when post with message, link and picture" do
      let(:post) { {:picture => picture , :message => message, :link => link} }

      it "should call put_picture method with message and picture params" do
        api.should_receive(:put_picture).
            with(picture, {:message => message}, group[:id]).
            and_return(response)
        publisher.run
      end
    end

    context "when post with blank fields" do
      let(:post) { Hash.new }

      it "should call put_picture method without params" do
        api.should_receive(:put_wall_post).
            with(nil, {}, group[:id]).
            and_return(response)
        publisher.run
      end
    end
  end

end
