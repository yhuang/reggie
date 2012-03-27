require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Reggie do
  context "new" do
    before :all do
      VCR.insert_cassette 'new', :record => :new_episodes
#      compression_url = "https://api.edgecast.com/v2/mcc/customers/#{EDGECAST_ACCOUNT[:customer_id]}/compression"
#      stub_request(:get, compression_url).with(:accept => :json, :authorization => 'valid').to_return(:status => 200)
    end

    after :all do
      VCR.eject_cassette
    end

    describe "with valid customer ID and valid authorization token" do
      it "should return valid Reggie object" do
        Reggie.new(:customer_id => EDGECAST_ACCOUNT[:customer_id], :token => EDGECAST_ACCOUNT[:token]).valid?.should be_true
      end
    end

    describe "with valid customer ID and invalid authorization token" do
      it "should return invalid Reggie object" do
        Reggie.new(:customer_id => "XXXX", :token => "invalid").valid?.should be_false
      end
    end

    describe "with invalid customer ID and valid authorization token" do
      it "should return invalid Reggie object" do
        Reggie.new(:customer_id => "XXXX", :token => "valid").valid?.should be_false
      end
    end

    describe "with invalid customer ID and invalid authorization token" do
      it "should return invalid Reggie object" do
        Reggie.new(:customer_id => "XXXX", :token => "invalid").valid?.should be_false
      end
    end
  end

  context "load" do
    before :all do
      @reg = Reggie.new(:customer_id => EDGECAST_ACCOUNT[:customer_id], :token => EDGECAST_ACCOUNT[:token])
      @urls = {
        :empty => "",
        :non_existent => "http://img.bleacherreport.net/img/slides/photos/002/037/135/XXX_crop_exact.jpg?w=650&h=440&q=85",
        :valid => "http://img.bleacherreport.net/img/slides/photos/002/037/135/137267039_crop_exact.jpg?w=650&h=440&q=85",
        :wrong_domain => "http://www.amazon.com",
      }

      VCR.insert_cassette 'load', :record => :new_episodes
    end

    after :all do
      VCR.eject_cassette
    end

    describe "valid cached image" do
      it "should return a 200 response" do
        @reg.load(@urls[:valid]).code.should == 200
      end
    end

    describe "empty URL" do
      it "should return a RestClient::BadRequest" do
        @reg.load(@urls[:empty]).should be_a RestClient::BadRequest
      end
    end

    describe "image from wrong domain" do
      it "should return a RestClient::BadRequest" do
        @reg.load(@urls[:wrong_domain]).should be_a RestClient::BadRequest
      end
    end

    describe "non-existent cached image" do
      it "should return a 200 response" do
        @reg.load(@urls[:non_existent]).code.should == 200
      end
    end
  end
end
