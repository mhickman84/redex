require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe FileGenerator do
    before :each do
      Redex.configure do |c|
        c.write_path = File.expand_path("spec/dictionary_files")
      end
      @lines = ['one', 'two', 'three']
      @file = FileGenerator.create_file 'sample.txt', @lines
    end

    it "should create a dictionary file when given an array" do
      File.exist?(File.expand_path(@file)).should be_true
    end

    it "should have one line for each item in the array" do
      IO.readlines(@file)[0].chomp.should == "one"
      IO.readlines(@file)[2].chomp.should == "three"
    end

    it "should create a dictionary file from an html page" do
      html_doc = get_sample 'mock_web_page.html'
      FileGenerator.stub!(:open_page).and_return(html_doc)
      dictionary = FileGenerator.generate('sample', 'http://www.fakeurl.com', '#list li')
      File.exist?(File.expand_path(dictionary)).should be_true
      IO.readlines(dictionary)[1].chomp.should == 'dos'
    end

    it "should create a dictionary file from xml content" do
      xml_doc = get_sample 'mock_xml_doc.xml'
      FileGenerator.stub!(:open_page).and_return(xml_doc)
      dictionary = FileGenerator.generate('sample', 'http://www.fakeurl.com', '//dog')
      File.exist?(File.expand_path(dictionary)).should be_true
      IO.readlines(dictionary)[0].chomp.should == 'Labrador Retriever'
    end

    it "should create a dictionary file from a .csv file" do
      csv = File.expand_path('zeppelin_members.csv', "spec/data")
      dictionary = FileGenerator.generate('zeppelin_members.txt', csv)
      File.exist?(File.expand_path(dictionary)).should be_true
      IO.readlines(dictionary)[0].chomp.should == 'Robert Plant'
      IO.readlines(dictionary)[3].chomp.should == 'John Paul Jones'
    end

    it "should accept multiple selectors for html/xml content" do
      html_doc = get_sample('mock_web_page.html')
      FileGenerator.stub!(:open_page).and_return(html_doc)
      dictionary = FileGenerator.generate('sample', 'http://www.fakeurl.com', 'h1', 'h2', 'p')
      File.exist?(File.expand_path(dictionary)).should be_true
      IO.readlines(dictionary)[0].chomp.should == 'Title'
      IO.readlines(dictionary)[2].chomp.should == 'Paragraph.'
    end

    it "should raise an exception if no dictionary items are found" do
      xml_doc = get_sample 'mock_xml_doc.xml'
      msg = FileGenerator.send :empty_msg
      lambda {
        FileGenerator.generate('sample', 'http://www.fakeurl.com', 'cat')
      }.should raise_error(RuntimeError, msg)
    end

    after :each do
      File.delete @file if File.exist? @file
    end

    def get_sample(file_name)
      file_path = File.expand_path(file_name, "spec/data")
      file = File.open(file_path)
      doc = Nokogiri.parse(file)
      file.close
      doc
    end
  end
end