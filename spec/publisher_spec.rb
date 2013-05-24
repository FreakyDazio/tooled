require "toolbox/publisher"

describe Toolbox::Publisher do
  let(:klass) do
    Class.new do
      include Toolbox::Publisher
      publishable_events :foo, :bar
    end
  end
  subject { klass }

  describe "allows a class to register events" do
    its(:publishable_events_list) { should include(:foo, :bar) }

    describe "remains unique" do
      subject { klass.publishable_events_list }
      specify { expect { klass.register_event(:blegga) }.to change { klass.publishable_events_list.count }.by(1) }
      specify { expect { klass.register_event(:foo) }.to_not change { klass.publishable_events_list.count } }
    end
  end

  describe "registering subscribers" do
    let(:subscriber) { double(:subscriber) }

    context "at class level" do
      specify { expect { subject.register_subscriber(subscriber, :foo, :bar) }.to change { subject.subscribers.count }.by(1) }

      context "when already subscribed" do
        before { subject.register_subscriber(subscriber, :foo) }
        specify { expect { subject.register_subscriber(subscriber, :foo) }.to_not change { subject.subscribers.count } }

        it "lists the correct event for the subscriber" do
          subject.subscribers[subscriber].include?(:foo)
        end
      end

      context "with invalid event" do
        specify { expect { subject.register_subscriber(subscriber, :invalid) }.to raise_error(Toolbox::Publisher::EventMissingException) }
      end
    end

    context "at object level" do
      let(:object) { klass.new }
      subject { object }

      specify { expect { subject.register_subscriber(subscriber, :foo, :bar) }.to change { subject.subscribers.count }.by(1) }

      context "when already subscribed" do
        before { subject.register_subscriber(subscriber, :foo) }
        specify { expect { subject.register_subscriber(subscriber, :foo) }.to_not change { subject.subscribers.count } }

        it "lists the correct event for the subscriber" do
          subject.subscribers[subscriber].include?(:foo)
        end
      end

      context "with invalid event" do
        specify { expect { subject.register_subscriber(subscriber, :invalid) }.to raise_error(Toolbox::Publisher::EventMissingException) }
      end
    end
  end

  describe "using events" do
    let(:subscriber) { double(:subscriber, before_foo: true, after_foo: true, around_foo: true) }
    let(:klass) do
      Class.new do
        include Toolbox::Publisher
        publishable_events :foo, :bar

        def using_foo
          with_event(:foo) { 1 }
        end

        def using_bar
          with_event(:bar) { 2 }
        end

        def using_blegga
          with_event(:blegga) { 3 }
        end
      end
    end

    subject { klass.new }

    context "having a subscriber" do
      before do
        subscriber.should_receive(:before_foo)
        subscriber.should_receive(:after_foo)
        subscriber.should_receive(:around_foo).twice
        subject.register_subscriber(subscriber, :foo)
      end

      its(:using_foo) { should eql(1) }
    end

    context "having no subscriber" do
      its(:using_bar) { should eql(2) }
    end

    context "having no event" do
      specify { expect { subject.using_blegga }.to raise_error(Toolbox::Publisher::EventMissingException) }
    end
  end
end
