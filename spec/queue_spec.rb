require "toolbox/queue"

describe Toolbox::Queue do
  let(:object) { Toolbox::Queue.new }
  subject { object }

  describe "adding elements" do
    specify { expect { subject << 1 }.to change { subject.count }.by(1) }
    specify { expect { subject.push(1) }.to change { subject.count }.by(1) }
  end

  describe "with no elements" do
    it { should be_empty }
  end

  describe "converting to array" do
    before { object << 1; object << 2; object << 3 }
    its(:to_a) { should eql([3, 2, 1]) }
  end

  describe "retrieving elements" do
    before { object << 'bottom' ; object << 'top' }

    context "using peek" do
      its(:peek) { should eql('bottom') }
      specify { expect { subject.peek }.to_not change { subject.count } }
    end

    context "using pop" do
      its(:pop) { should eql('bottom') }
      specify { expect { subject.pop }.to change { subject.count }.by(-1) }
    end

    context "using an index" do
      context "of 0" do
        subject { object[0] }
        it { should eql('bottom') }
      end

      context "of 1" do
        subject { object[1] }
        it { should eql('top') }
      end
    end
  end

  describe "is iterable" do
    before { object << 1; object << 2; object << 3 }
    specify do
      expect do
        values = []
        object.each { |v| values << v }
        values.should include(3, 2, 1)
      end.to change { object.count }.by(-3)
    end
  end
end
