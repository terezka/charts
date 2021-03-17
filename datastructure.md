The data structures are similar across charts – the first 2 will just use a time-series grouping on events, and the last one that shows individual events on a timeline will filter a subset of that same data and just show it outright.
9:48
Here are the schemas if helpful:
9:48
create table if not exists "events_test-local" (
  "id"        serial primary key,
  "pos"       integer,            -- max: 2147483647, only set for actual msg events
  "version"   integer not null,   -- max: 2147483647, app version
  "tipe"      smallint not null,  -- max: 32767, event type, see lbr.elm:serialize
  "start"     timestamp not null, -- microsecond precision, event start time
  "duration"  integer not null default -1, -- msg processing duration
                                  -- microseconds, 0 indicates < 1μs
                                  -- max: 2147483647 = ~35 minutes max duration
  "wire"      integer not null default -1, -- microseconds, wire encoding duration
                                  -- max: 2147483647 = ~35 minutes max duration
  "bytes"     bytea               -- possibly a bytes payload depending on the tipe
);
9:49
And the query ends up in Elm as this type currently:
type alias LogIntervalSummary =
    { start : Time.Posix
    , tipe : Int
    , count : Int
    }
9:50
Here's what the result of the timeseries query looks like:
Screenshot 2021-03-12 at 15.49.59.png
Screenshot 2021-03-12 at 15.49.59.png


9:50
Based on this query:
    select * from
      ( select
          date_trunc('second', start) as s,
          tipe as t,
          count(tipe)::integer as c
        from "events_test-local"
        group by date_trunc('second', start), t
        order by s desc
        limit 10
      ) as subq
    order by s asc;
9:51
So it's basically grouped by both a 1 second time window, and an event type.
9:52
The only thing that's missing is windows without any events – so I have to "pad" that on client side with 0 values for the missing time intervals, if that makes sense. Would be cool if the library did that automatically (i.e. is happy to handle a time series where not all intervals have values in the data set), but perhaps that's too niche!
9:55
Hope that makes sense!