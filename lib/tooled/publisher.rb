##
#   Publisher provides a barebones implementation to a pub-sub system.
#
#   By including the Publisher into any class you can then regsiter events
#   and wrap blocks in `with_event` which will then broadcast the event to
#   any registered subscribers.

module Tooled
  module Publisher

    ##
    #   Used to distinguish exceptions relating to the lack of a particular
    #   event.

    class EventMissingException < Exception ; end

    def self.included(base)
      base.extend(ClassMethods)
    end

    ##
    #   Returns a complete hash of subscribers including those registered at
    #   class level.

    def subscribers
      (@subscribers ||= self.class.subscribers).dup
    end

    ##
    #   Registers a subscriber to an instance.
    #
    #   This will raise an EventMissing exception if any of the provided event
    #   names aren't registered.

    def register_subscriber(subscriber, *event_names)
      @subscribers ||= self.class.subscribers
      events = event_names.collect(&:to_sym).uniq
      invalid_events = events - self.class.publishable_events_list
      raise EventMissingException.new("`#{invalid_events.collect(&:to_s).join('`, `')}` are not registered events") unless invalid_events.empty?
      @subscribers[subscriber] = events
    end

    ##
    #   Executes a provided block but calls all the events on relevant subscribers
    #   as well.
    #
    #   `before_event_name` -> `around_event_name` -> `around_event_name` -> `after_event_name`

    def with_event(event_name, &block)
      raise EventMissingException.new("`#{event_name.to_s}` is not a registered event") unless self.class.publishable_events_list.include?(event_name.to_sym)
      subs = _subscribers_for(event_name)
      _broadcast(subs, ["before_#{event_name.to_s}", "around_#{event_name.to_s}"])
      result = block.call if block_given?
      _broadcast(subs, ["around_#{event_name.to_s}", "after_#{event_name.to_s}"])
      result
    end

    private

    def _subscribers_for(event_name)
      subscribers.select { |subscriber, events| events.include?(event_name.to_sym) }.keys
    end

    def _broadcast(subs, method)
      subs.each do |subscriber|
        if method.is_a?(Array)
          method.each { |m| subscriber.send(m) if subscriber.respond_to?(m) }
        else
          subscriber.send(method.to_s) if subscriber.respond_to?(method.to_s)
        end
      end
    end

    module ClassMethods

      ##
      #   Sets the list of publishable events. If an event is not registered
      #   as a publishable event then it will not fire.

      def publishable_events(*event_names)
        @publishable_events = event_names.collect(&:to_sym).uniq
      end

      ##
      #   Registers an individual event without removing previously added events.

      def register_event(event_name)
        event_name = event_name.to_sym
        @publishable_events ||= Array.new
        @publishable_events << event_name unless @publishable_events.include?(event_name)
      end

      ##
      #   Provides an array with all publishable event names.

      def publishable_events_list
        (@publishable_events ||= Array.new).dup
      end

      ##
      #   Provides a hash with all subscribers and their associated events.

      def subscribers
        (@subscribers ||= Hash.new).dup
      end

      ##
      #   Registers an individual subscriber to any number of events from a class
      #   level.

      def register_subscriber(subscriber, *event_names)
        @subscribers ||= Hash.new
        events = event_names.collect(&:to_sym).uniq
        invalid_events = events - publishable_events_list
        raise EventMissingException.new("`#{invalid_events.collect(&:to_s).join('`, `')}` are not registered events") unless invalid_events.empty?
        @subscribers[subscriber] = events
      end
    end
  end
end
