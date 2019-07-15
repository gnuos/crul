require "../spec_helper"

describe "Basic examples" do
  it "no args" do
    lines = capture_lines do |output|
      Crul::CLI.run!([] of String, output).should be_false
    end

    lines.first.should match(/\AUsage:/)
    lines.last.should match(/Please specify URL/)
  end

  it "help" do
    lines = capture_lines do |output|
      Crul::CLI.run!(["-h"], output).should be_true
    end

    lines.first.should match(/\AUsage:/)
  end

  it "most basic GET" do
    WebMock.stub(:get, "http://example.org/").to_return(body: "Hello", headers: {"Hello" => "World"})

    lines = capture_lines do |output|
      Crul::CLI.run!(["http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.should contain("Hello: World")
    lines.last.should eq("Hello")
  end

  it "colorizes output" do
    WebMock.stub(:get, "http://example.org/").to_return(body: "Hello", headers: {"Hello" => "World"})

    lines = capture_lines(uncolorize?: false) do |output|
      Crul::CLI.run!(["http://example.org"], output).should be_true
    end

    lines.first.should eq("\e[94mHTTP/1.1\e[0m\e[36m 200 \e[0m\e[33mOK")
    lines.should contain("\e[0mHello: \e[36mWorld")
    lines.last.should eq("Hello")
  end

  it "most basic GET with https" do
    WebMock.stub(:get, "https://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["https://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "most basic GET without protocol (should default to http://)" do
    WebMock.stub(:get, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "most basic GET with port" do
    WebMock.stub(:get, "http://example.org:8080/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["http://example.org:8080/"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "basic POST" do
    WebMock.stub(:post, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["post", "http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "basic PUT" do
    WebMock.stub(:put, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["put", "http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "basic DELETE" do
    WebMock.stub(:delete, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["delete", "http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end
end
