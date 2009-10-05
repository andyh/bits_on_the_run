require File.dirname(__FILE__) + '/../spec_helper'

include BitsOnTheRun

describe Video do
  before(:each) do
    Initializer.run do |config|
      config.api_key    = 'api key'
      config.api_secret = 'api secret'
    end
  end

  after(:each) do
    Configuration.api_key    = nil
    Configuration.api_secret = nil
  end
  
  describe "Getting a video from the API (/video/show)" do
    before(:each) do
      client = Client.new('/some/action')
      client.stub!(:response).and_return REXML::Document.new <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <response>
        <status>ok</status>
        <video key="yYul4DRz">
          <author>Bits on the Run</author>
          <date>1225962900</date>
          <description>New video</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video</title>
        </video>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @video = Video.show("yYul4DRz")
    end

    it "should return a video instance" do
      @video.should be_a(Video)
    end

    it "should have the video key supplied by the API" do
      @video.key.should == "yYul4DRz"
    end

    it "should have the author 'Bits on the Run'" do
      @video.author.should == "Bits on the Run"
    end

    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @video.date.should == Time.at(1225962900)
    end

    it "should have the description 'New video'" do
      @video.description.should == "New video"
    end

    it "should have the duration 12 seconds" do
      @video.duration.to_i.should == 12.seconds
    end

    it "should have the link 'http://www.bitsontherun.com'" do
      @video.link.should == 'http://www.bitsontherun.com'
    end

    it "should have the tags 'new' and 'video'" do
      @video.tags.should == ["new", "video"]
    end

    it "should have the title 'New test video'" do
      @video.title.should == 'New test video'
    end
  end

  describe "Getting videos from the API (/videos/list)" do
    before(:each) do
      client = Client.new('/videos/list')
      client.stub!(:response).and_return REXML::Document.new <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
	<response>
  	<status>ok</status>
  	<videos total="2">
        <video key="yYul4DRz1">
          <author>Bits on the Run 1</author>
          <date>1225962900</date>
          <description>New video 1</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video 1</title>
        </video>

        <video key="yYul4DRz2">
          <author>Bits on the Run 2</author>
          <date>1225972900</date>
          <description>New video 2</description>
          <duration>16.0</duration>
          <link>http://www.bitsontherun2.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video 2</title>
        </video>
       </videos>
     </response>
      XML
      Client.stub!(:new).and_return(client)
      @videos = Video.list
    end

    it "should return two video instances" do
      @videos.first.should be_a(Video)
      @videos.size.should == 2
    end
    
    it "should have the video key supplied by the API" do
      @videos.first.key.should == "yYul4DRz1"
    end
     
    it "should have the author 'Bits on the Run'" do
      @videos.first.author.should == "Bits on the Run 1"
    end
    
    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @videos.first.date.should == Time.at(1225962900)
    end
    
    it "should have the description 'New video'" do
      @videos.first.description.should == "New video 1"
    end

    it "should have the duration 12 seconds" do
      @videos.first.duration.to_i.should == 12.seconds
    end

    it "should have the link http://www.bitsontherun.com'" do
      @videos.first.link.should == "http://www.bitsontherun.com"
    end
    
    it "should have the tags 'new' and 'video'" do
      @videos.first.tags.should == ["new", "video"]
    end
    
    it "should have the title 'New test video'" do
      @videos.first.title.should == 'New test video 1'
    end

  end


  describe "Getting videos from the API (/videos/list/?sort_order=date-asc) sort by date ascending" do
    before(:each) do
      options = '?sort_order=date-asc'
      client = Client.new('/some/action/')
      client.stub!(:response).and_return REXML::Document.new <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <response>
      <status>ok</status>
      <videos total="2">
        <video key="yYul4DRz1">
          <author>Bits on the Run One</author>
          <date>1225962900</date>
          <description>New video one</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video, one</tags>
          <title>New test video one</title>
        </video>

        <video key="yYul4DRz2">
          <author>Bits on the Run Two</author>
          <date>1225962910</date>
          <description>New video two</description>
          <duration>16.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video, two</tags>
          <title>New test video two</title>
        </video>
      </videos>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @videos = Video.list(options)
    end

    it "should return two video instances" do
      @videos.first.should be_a(Video)
      @videos.size.should == 2
    end

    it "should have the video key supplied by the API" do
      @videos.first.key.should == "yYul4DRz1"
    end

    it "should have the author 'Bits on the Run One'" do
      @videos.first.author.should == "Bits on the Run One"
    end

    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @videos.first.date.should == Time.at(1225962900)
    end

    it "should have the description 'New video one'" do
      @videos.first.description.should == "New video one"
    end

    it "should have the duration 12 seconds" do
      @videos.first.duration.to_i.should == 12.seconds
    end

    it "should have the link http://www.bitsontherun.com'" do
      @videos.first.link.should == "http://www.bitsontherun.com"
    end

    it "should have the tags 'new' and 'video' and 'one'" do
      @videos.first.tags.should == ["new", "video", "one"]
    end

    it "should have the title 'New test video one'" do
      @videos.first.title.should == 'New test video one'
    end
  end

  describe "Getting videos from the API tag newest, video (/videos/list/?tag=newest,video)" do
    before(:each) do
      options = '?tag=newest,video'
      client = Client.new('/some/action/')
      client.stub!(:response).and_return REXML::Document.new <<-XML
	  <?xml version="1.0" encoding="UTF-8"?>
	  <response>
  	  <status>ok</status>
  	  <videos total="2">
        <video key="yYul4DRz1">
          <author>Bits on the Run 1</author>
          <date>1225962900</date>
          <description>New video 1</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video 1</title>
        </video>

        <video key="yYul4DRz2">
          <author>Bits on the Run 2</author>
          <date>1225972901</date>
          <description>New video 2</description>
          <duration>16.0</duration>
          <link>http://www.bitsontherun2.com</link>
          <status>ready</status>
          <tags>newest, video</tags>
          <title>New test video 2</title>
        </video>
      </videos>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @videos = Video.list(options)
    end

    it "should return two video instances" do
      @videos.last.should be_a(Video)
      @videos.size.should == 2
    end

    it "should have the video key supplied by the API" do
      @videos.last.key.should == "yYul4DRz2"
    end

    it "should have the author 'Bits on the Run'" do
      @videos.last.author.should == "Bits on the Run 2"
    end

    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @videos.last.date.should == Time.at(1225972901)
    end

    it "should have the description 'New video'" do
      @videos.last.description.should == "New video 2"
    end

    it "should have the duration 16 seconds" do
      @videos.last.duration.to_i.should == 16.seconds
    end

    it "should have the link http://www.bitsontherun2.com'" do
      @videos.last.link.should == "http://www.bitsontherun2.com"
    end

    it "should have the tags 'newest' and 'video'" do
      @videos.last.tags.should == ["newest", "video"]
    end

    it "should have the title 'New test video 2'" do
      @videos.last.title.should == 'New test video 2'
    end

  end

  describe "Getting videos from the API tag newest, video (/videos/list/?total_limit=1)" do
    before(:each) do
      options = '?total_limit=1'
      client = Client.new('/some/action/')
      client.stub!(:response).and_return REXML::Document.new <<-XML
	  <?xml version="1.0" encoding="UTF-8"?>
	  <response>
  	  <status>ok</status>
  	  <videos total="2">
        <video key="yYul4DRz1">
          <author>Bits on the Run 1</author>
          <date>1225962900</date>
          <description>New video 1</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video 1</title>
        </video>

        <video key="yYul4DRz2">
          <author>Bits on the Run 2</author>
          <date>1225972901</date>
          <description>New video 2</description>
          <duration>16.0</duration>
          <link>http://www.bitsontherun2.com</link>
          <status>ready</status>
          <tags>newest, video</tags>
          <title>New test video 2</title>
        </video>
      </videos>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @videos = Video.list(options)
    end

    it "should return two video instances" do
      @videos.first.should be_a(Video)
      @videos.size.should == 2
    end

    it "should have the video key supplied by the API" do
      @videos.first.key.should == "yYul4DRz1"
    end

    it "should have the author 'Bits on the Run 1'" do
      @videos.first.author.should == "Bits on the Run 1"
    end

    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @videos.first.date.should == Time.at(1225962900)
    end

    it "should have the description 'New video 1'" do
      @videos.first.description.should == "New video 1"
    end

    it "should have the duration 12 seconds" do
      @videos.first.duration.to_i.should == 12.seconds
    end

    it "should have the link http://www.bitsontherun.com'" do
      @videos.first.link.should == "http://www.bitsontherun.com"
    end

    it "should have the tags 'new' and 'video'" do
      @videos.first.tags.should == ["new", "video"]
    end

    it "should have the title 'New test video 1'" do
      @videos.first.title.should == 'New test video 1'
    end

  end

  describe "Getting videos from the API page_limit is one (/videos/list/?page_limit=1)" do
    before(:each) do
      options = '?page_limit=1'
      client = Client.new('/some/action/')
      client.stub!(:response).and_return REXML::Document.new <<-XML
	  <?xml version="1.0" encoding="UTF-8"?>
	  <response>
  	  <status>ok</status>
  	  <videos total="2">
        <video key="yYul4DRz1">
          <author>Bits on the Run 1</author>
          <date>1225962900</date>
          <description>New video 1</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video 1</title>
        </video>

        <video key="yYul4DRz2">
          <author>Bits on the Run 2</author>
          <date>1225972901</date>
          <description>New video 2</description>
          <duration>16.0</duration>
          <link>http://www.bitsontherun2.com</link>
          <status>ready</status>
          <tags>newest, video</tags>
          <title>New test video 2</title>
        </video>
      </videos>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @videos = Video.list(options)
    end

    it "should return two video instances" do
      @videos.first.should be_a(Video)
      @videos.size.should == 2
    end

    it "should have the video key supplied by the API" do
      @videos.first.key.should == "yYul4DRz1"
    end

    it "should have the author 'Bits on the Run 1'" do
      @videos.first.author.should == "Bits on the Run 1"
    end

    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @videos.first.date.should == Time.at(1225962900)
    end

    it "should have the description 'New video 1'" do
      @videos.first.description.should == "New video 1"
    end

    it "should have the duration 12 seconds" do
      @videos.first.duration.to_i.should == 12.seconds
    end

    it "should have the link http://www.bitsontherun.com'" do
      @videos.first.link.should == "http://www.bitsontherun.com"
    end

    it "should have the tags 'new' and 'video'" do
      @videos.first.tags.should == ["new", "video"]
    end

    it "should have the title 'New test video 1'" do
      @videos.first.title.should == 'New test video 1'
    end

  end

   describe "Getting videos from the API total_limit is one (/videos/list/?total_limit=1)" do
    before(:each) do
      options = '?total_limit=1'
      client = Client.new('/some/action/')
      client.stub!(:response).and_return REXML::Document.new <<-XML
	  <?xml version="1.0" encoding="UTF-8"?>
	  <response>
  	  <status>ok</status>
  	  <videos total="2">
        <video key="yYul4DRz1">
          <author>Bits on the Run 1</author>
          <date>1225962900</date>
          <description>New video 1</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video 1</title>
        </video>

        <video key="yYul4DRz2">
          <author>Bits on the Run 2</author>
          <date>1225972901</date>
          <description>New video 2</description>
          <duration>16.0</duration>
          <link>http://www.bitsontherun2.com</link>
          <status>ready</status>
          <tags>newest, video</tags>
          <title>New test video 2</title>
        </video>
      </videos>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @videos = Video.list(options)
    end

    it "should return two video instances" do
      @videos.first.should be_a(Video)
      @videos.size.should == 2
    end

    it "should have the video key supplied by the API" do
      @videos.first.key.should == "yYul4DRz1"
    end

    it "should have the author 'Bits on the Run 1'" do
      @videos.first.author.should == "Bits on the Run 1"
    end

    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @videos.first.date.should == Time.at(1225962900)
    end

    it "should have the description 'New video 1'" do
      @videos.first.description.should == "New video 1"
    end

    it "should have the duration 12 seconds" do
      @videos.first.duration.to_i.should == 12.seconds
    end

    it "should have the link http://www.bitsontherun.com'" do
      @videos.first.link.should == "http://www.bitsontherun.com"
    end

    it "should have the tags 'new' and 'video'" do
      @videos.first.tags.should == ["new", "video"]
    end

    it "should have the title 'New test video 1'" do
      @videos.first.title.should == 'New test video 1'
    end

  end

  describe "Getting videos from the API text is New video one  (/videos/list/?text=New video one)" do
    before(:each) do
      options = '?page_limit=1'
      client = Client.new('/some/action/')
      client.stub!(:response).and_return REXML::Document.new <<-XML
	  <?xml version="1.0" encoding="UTF-8"?>
	  <response>
  	  <status>ok</status>
  	  <videos total="2">
        <video key="yYul4DRz1">
          <author>Bits on the Run One</author>
          <date>1225962900</date>
          <description>New video One</description>
          <duration>12.0</duration>
          <link>http://www.bitsontherun.com</link>
          <status>ready</status>
          <tags>new, video</tags>
          <title>New test video One</title>
        </video>

        <video key="yYul4DRz2">
          <author>Bits on the Run Two</author>
          <date>1225972901</date>
          <description>New video Two</description>
          <duration>16.0</duration>
          <link>http://www.bitsontherun2.com</link>
          <status>ready</status>
          <tags>newest, video</tags>
          <title>New test video Two</title>
        </video>
      </videos>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @videos = Video.list(options)
    end

    it "should return two video instances" do
      @videos.first.should be_a(Video)
      @videos.size.should == 2
    end

    it "should have the video key supplied by the API" do
      @videos.first.key.should == "yYul4DRz1"
    end

    it "should have the author 'Bits on the Run One'" do
      @videos.first.author.should == "Bits on the Run One"
    end

    it "should have the date 'Thu Nov 06 09:15:00 +0000 2008'" do
      @videos.first.date.should == Time.at(1225962900)
    end

    it "should have the description 'New video One'" do
      @videos.first.description.should == "New video One"
    end

    it "should have the duration 12 seconds" do
      @videos.first.duration.to_i.should == 12.seconds
    end

    it "should have the link http://www.bitsontherun.com'" do
      @videos.first.link.should == "http://www.bitsontherun.com"
    end

    it "should have the tags 'new' and 'video'" do
      @videos.first.tags.should == ["new", "video"]
    end

    it "should have the title 'New test video One'" do
      @videos.first.title.should == 'New test video One'
    end

  end


end


