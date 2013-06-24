require "tooled/tree_node_collection"

describe Tooled::TreeNodeCollection do
  let(:object) { Tooled::TreeNodeCollection.new }
  subject { object }

  describe "add" do
    context "TreeNode to collection" do
      specify { expect { object.add(Tooled::TreeNode.new) }.to change { object.size }.by(1) }
      specify { expect { object << Tooled::TreeNode.new }.to change { object.size }.by(1) }
    end

    context "raises if not provided a TreeNode" do
      specify { expect { object.add(String.new) }.to raise_error(Tooled::InvalidNodeException) }
      specify { expect { object << String.new }.to raise_error(Tooled::InvalidNodeException) }
    end
  end
end
