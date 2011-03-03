require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe  DocumentContent do
    before :each do
      @content = DocumentContent.new
    end

    it { should respond_to :parent }

    it "should be a top level section if no parent has been assigned" do
      @content.top_level?.should be_true
      @content.parent = DocumentContent.new
      @content.top_level?.should be_false
    end
  end
end