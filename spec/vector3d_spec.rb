require "tooled/vector3d"

describe Tooled::Vector3D do
  let(:object) { Tooled::Vector3D.new(1, 2, 3) }
  subject { object }

  context "when initialized with values" do
    its(:x) { should eql(1.to_f) }
    its(:y) { should eql(2.to_f) }
    its(:z) { should eql(3.to_f) }
  end

  describe "when multiplied" do
    context "with an integer" do
      subject { object * 2 }
      its(:x) { should eql(2.to_f) }
      its(:y) { should eql(4.to_f) }
      its(:z) { should eql(6.to_f) }
    end

    context "with a float" do
      subject { object * 1.5 }
      its(:x) { should eql(1.5.to_f) }
      its(:y) { should eql(3.to_f) }
      its(:z) { should eql(4.5.to_f) }
    end

    context "with a vector3d" do
      context "using integer values" do
        subject { object * Tooled::Vector3D.new(2, 5, 10) }
        its(:x) { should eql(2.to_f) }
        its(:y) { should eql(10.to_f) }
        its(:z) { should eql(30.to_f) }
      end

      context "using float values" do
        subject { object * Tooled::Vector3D.new(1.5, 2.5, 3.5) }
        its(:x) { should eql(1.5.to_f) }
        its(:y) { should eql(5.to_f) }
        its(:z) { should eql(10.5.to_f) }
      end
    end
  end

  describe "when divided" do
    let(:object) { Tooled::Vector3D.new(5, 10, 15) }
    context "with an integer" do
      subject { object / 5 }
      its(:x) { should eql(1.to_f) }
      its(:y) { should eql(2.to_f) }
      its(:z) { should eql(3.to_f) }
    end

    context "with a float" do
      subject { object / 2.5 }
      its(:x) { should eql(2.to_f) }
      its(:y) { should eql(4.to_f) }
      its(:z) { should eql(6.to_f) }
    end

    context "with a vector3d" do
      context "using integer values" do
        subject { object / Tooled::Vector3D.new(5, 10, 15) }
        its(:x) { should eql(1.to_f) }
        its(:y) { should eql(1.to_f) }
        its(:z) { should eql(1.to_f) }
      end

      context "using float values" do
        subject { object / Tooled::Vector3D.new(2.5, 1.25, 2.5) }
        its(:x) { should eql(2.to_f) }
        its(:y) { should eql(8.to_f) }
        its(:z) { should eql(6.to_f) }
      end
    end
  end

  describe "when added" do
    context "with a vector3d" do
      subject { object + Tooled::Vector3D.new(1, 5, 10) }
      its(:x) { should eql(2.to_f) }
      its(:y) { should eql(7.to_f) }
      its(:z) { should eql(13.to_f) }
    end
  end

  describe "when subtracted" do
    context "with a vector3d" do
      subject { object - Tooled::Vector3D.new(1, 5, 10) }
      its(:x) { should eql(0.to_f) }
      its(:y) { should eql(-3.to_f) }
      its(:z) { should eql(-7.to_f) }
    end
  end
end
