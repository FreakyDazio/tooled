require "tooled/tree_node"

describe Tooled::TreeNode do
  let(:object) { Tooled::TreeNode.new }
  subject { object }

  its(:children) { should be_instance_of(Tooled::TreeNodeCollection) }

  describe "reports all descendants" do
    subject { object.descendants }

    before do
      object.children << Tooled::TreeNode.new
      object.children << Tooled::TreeNode.new
      object.children << Tooled::TreeNode.new.tap do |node_a|
        node_a.children << Tooled::TreeNode.new.tap do |node_b|
          node_b.children << Tooled::TreeNode.new
        end
      end
    end

    it { should be_instance_of(Tooled::TreeNodeCollection) }
    its(:size) { should eql(5) }
  end

  describe "reports all ancestors" do
    subject { object.ancestors }

    before do
      object.parent = Tooled::TreeNode.new.tap do |node_a|
        node_a.parent = Tooled::TreeNode.new.tap do |node_b|
          node_b.parent = Tooled::TreeNode.new.tap do |node_c|
            node_c.parent = Tooled::TreeNode.new
          end
        end
      end
    end

    it { should be_instance_of(Tooled::TreeNodeCollection) }
    its(:size) { should eql(4) }
  end

  describe "setting the parent" do
    context "to an invalid object" do
      specify { expect { object.parent = String.new }.to raise_error(Tooled::InvalidNodeException) }
    end

    context "to a TreeNode" do
      let(:parent) { Tooled::TreeNode.new }
      before { object.parent = parent }

      it "adds self to parents children" do
        parent.children.to_a.should include(object)
      end

      its(:parent) { should eql(parent) }
    end

    context "to a child" do
      let(:child) { Tooled::TreeNode.new }
      before { object.children.add(child) }

      specify { expect { object.parent = child }.to raise_error(Tooled::InvalidNodeException) }
    end
  end
end
