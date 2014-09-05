require 'spec_helper'

describe Stache::Mustache::CachedTemplate do
  before do
    @source   = "{{hello}} mustache"
    @template = Stache::Mustache::CachedTemplate.new(@source)
  end

  it "can be dumped when compiled" do
    @template.compile
    dump = Marshal.dump(@template)
    dump.should =~ /ctx\[:hello\]/
    dump.should =~ /mustache/
  end

  it "can be loaded from valid dump" do
    @template.compile
    obj = Marshal.load(Marshal.dump(@template))
    obj.compile.should eq(@template.compile)
  end

  it "should ignore source if already compiled" do
    res   = @template.compile
    res2 =  @template.compile("{{foo}} bar")
    res.should eq(res2)
  end
end