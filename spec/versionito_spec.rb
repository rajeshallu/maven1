require "spec_helper"

describe Versionito do
  subject { Versioned.new }

  describe "#new_version" do
    it "increments version properly" do
      expect(subject.version).to eql(1)
      expect(subject.versions.count).to eql(1)

      v2 = subject.new_version
      expect(v2.version).to eql(2)
      expect(v2.versions).to eql([subject, v2])

      v3 = v2.new_version
      expect(v3.version).to eql(3)
      expect(v3.versions).to eql([subject, v2, v3])
    end

    it "takes a block to handle custom logic" do
      new_title = "Something completely different"
      v1 = subject.new_version { |clone, original| clone.title = new_title  }
      expect(v1.title).to eql(new_title)
    end
  end

end
