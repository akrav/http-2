require "helper"

describe HTTP2::Emitter do
  class Worker
    include Emitter
  end

  before(:each) do
    @w = Worker.new
    @cnt = 0
  end

  it "should raise error on missing callback" do
    expect { @w.on(:a) {} }.to_not raise_error
    expect { @w.on(:a) }.to raise_error
  end

  it "should allow multiple callbacks on single event" do
    @w.on(:a) { @cnt += 1 }
    @w.on(:a) { @cnt += 1 }
    @w.emit(:a)

    @cnt.should eq 2
  end

  it "should execute callback with optional args" do
    args = nil
    @w.on(:a) { |a| args = a }
    @w.emit(:a, 123)

    args.should eq 123
  end

  it "should allow events with no callbacks" do
    expect { @w.emit(:missing) }.to_not raise_error
  end

  it "should execute callback exactly once" do
    @w.on(:a)   { @cnt += 1 }
    @w.once(:a) { @cnt += 1 }
    @w.emit(:a)
    @w.emit(:a)

    @cnt.should eq 3
  end
end
