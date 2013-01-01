# Add some stuff to ICS::Event.

module ICS

  class Event

    def started_on
      DateTime.parse(dtstart)
    end

  end

end
