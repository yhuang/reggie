require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Reggie do
  context "new" do
    before :all do
      VCR.insert_cassette 'new', :record => :new_episodes
    end

    after :all do
      VCR.eject_cassette
    end

    describe "with valid customer ID and valid authorization token" do
      it "should return valid Reggie object" do
        Reggie.new(:customer_id => EDGECAST_ACCOUNT['customer_id'], :token => EDGECAST_ACCOUNT['token']).valid?.should be_true
      end
    end

    describe "with valid customer ID and invalid authorization token" do
      it "should return invalid Reggie object" do
        Reggie.new(:customer_id => EDGECAST_ACCOUNT['customer_id'], :token => "XXXX").valid?.should be_false
      end
    end

    describe "with invalid customer ID and valid authorization token" do
      it "should return invalid Reggie object" do
        Reggie.new(:customer_id => "XXXX", :token => EDGECAST_ACCOUNT['token']).valid?.should be_false
      end
    end

    describe "with invalid customer ID and invalid authorization token" do
      it "should return invalid Reggie object" do
        Reggie.new(:customer_id => "XXXX", :token => "XXXX").valid?.should be_false
      end
    end
  end

  context "Cache Management" do
    before :all do
      @reg = Reggie.new(:customer_id => EDGECAST_ACCOUNT['customer_id'], :token => EDGECAST_ACCOUNT['token'])
      @urls = {
          :empty => "",
          :non_existent => "http://img.bleacherreport.net/img/slides/photos/002/037/135/XXX_crop_exact.jpg?w=650&h=440&q=85",
          :valid => "http://img.bleacherreport.net/img/slides/photos/002/037/135/137267039_crop_exact.jpg?w=650&h=440&q=85",
          :wrong_domain => "http://www.amazon.com",
      }

      VCR.insert_cassette 'cache_management', :record => :new_episodes
    end

    after :all do
      VCR.eject_cassette
    end

    [:load, :purge].each do |method|
      describe "#{method} valid cached image" do
        it "should return a 200 response" do
          @reg.send(method, @urls[:valid]).code.should == 200
        end
      end

      describe "#{method} non-existent cached image" do
        it "should return a 200 response" do
          @reg.send(method, @urls[:non_existent]).code.should == 200
        end
      end

      describe "#{method} empty URL" do
        it "should return a RestClient::BadRequest" do
          @reg.send(method, @urls[:empty]).should be_a RestClient::BadRequest
        end
      end

      describe "#{method} image from wrong domain" do
        it "should return a RestClient::BadRequest" do
          @reg.send(method, @urls[:wrong_domain]).should be_a RestClient::BadRequest
        end
      end
    end
  end
end
