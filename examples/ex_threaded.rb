require File.dirname(__FILE__) + '/helper'

EM.spawn_reactor_thread

EM.start_server 'localhost', 25431 do |c|
  def c.receive_data data
    send_data data.reverse
  end
end

$q = Queue.new

EM.connect 'localhost', 25431 do |c|
  c.send_data "foo"

  def c.receive_data data
    $q << data
  end
end

puts $q.pop

EM.kill_reactor_thread
