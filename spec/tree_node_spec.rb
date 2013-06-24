require "tooled/tree_node"

describe Tooled::TreeNode do
  let(:object) { Tooled::TreeNode.new }
  subject { object }

  its(:children) { should be_instance_of(Tooled::TreeNodeCollection) }

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
  end

  it "can be traversed"
end
