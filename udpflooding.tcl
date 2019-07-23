# setting up ns simulator
set ns [new Simulator]


$ns color 1 red
$ns color 2 blue

# opening the trace file
set tracefile1 [open out.tr w]
$ns trace-all $tracefile1

# Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Define  'finish' procedure
proc finish {} {
	global ns tracefile1 namfile
	$ns flush-trace
	close $tracefile1
	close $namfile
	exec nam out.nam &
	exit 0
}

# Create 14 nodes
for {set i 0} {$i<=14} {set i [incr i]} {
set n($i) [$ns node]
}

# Create duplex-links between nodes $ns duplex-link node1 node2 bandwidth delay queue-type
$ns duplex-link $n(0) $n(2) 0.2Mb 100ms DropTail
$ns duplex-link $n(1) $n(2) 0.2Mb 100ms DropTail
$ns duplex-link $n(2) $n(3) 0.2Mb 100ms DropTail
$ns duplex-link $n(3) $n(4) 0.2Mb 100ms DropTail
$ns duplex-link $n(4) $n(5) 0.2Mb 100ms DropTail
$ns duplex-link $n(5) $n(6) 0.2Mb 100ms DropTail
$ns duplex-link $n(5) $n(7) 0.2Mb 100ms DropTail
$ns duplex-link $n(5) $n(8) 0.2Mb 100ms DropTail
$ns duplex-link $n(4) $n(9) 2.0Mb 100ms DropTail
$ns duplex-link $n(9) $n(10) 0.5Mb 100ms DropTail
$ns duplex-link $n(9) $n(11) 0.5Mb 100ms DropTail
$ns duplex-link $n(9) $n(12) 0.5Mb 100ms DropTail
$ns duplex-link $n(9) $n(13) 0.5Mb 100ms DropTail
$ns duplex-link $n(4) $n(14) 0.2Mb 100ms DropTail

# Setting node positions
$ns duplex-link-op $n(3) $n(4) orient right
$ns duplex-link-op $n(4) $n(5) orient left-down
$ns duplex-link-op $n(4) $n(14) orient right
$ns duplex-link-op $n(2) $n(3) orient right-up
$ns duplex-link-op $n(9) $n(4) orient right-down
$ns duplex-link-op $n(2) $n(0) orient left-up
$ns duplex-link-op $n(2) $n(1) orient left-down
$ns duplex-link-op $n(9) $n(10) orient left
$ns duplex-link-op $n(9) $n(13) orient right
$ns duplex-link-op $n(9) $n(11) orient left-up
$ns duplex-link-op $n(9) $n(12) orient right-up
$ns duplex-link-op $n(5) $n(7) orient down
$ns duplex-link-op $n(5) $n(6) orient left-down
$ns duplex-link-op $n(5) $n(8) orient right-down
$n(3) set X_ 7
$n(3) set Y_ 3

#setting shape
$n(3) shape square
$n(4) shape square
$n(2) shape hexagon
$n(9) shape hexagon
$n(5) shape hexagon

#setting color
$n(10) color red
$n(11) color red
$n(12) color red
$n(13) color red
$n(9) color red

# Set Queue Sizes
$ns queue-limit $n(3) $n(4) 20
$ns queue-limit $n(9) $n(4) 20

# Labelling
$ns at 0.0 "$n(9) label attacker_network"
$ns at 0.0 "$n(14) label victim_server"
$ns at 0.0 "$n(2) label user_net"
$ns at 0.0 "$n(5) label user_net"

# Setup a TCP connection between n0 and n7 to n14
set tcp1 [new Agent/TCP]
set tcp2 [new Agent/TCP]
$ns attach-agent $n(0) $tcp1
$ns attach-agent $n(7) $tcp2
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n(14) $sink1
$ns attach-agent $n(14) $sink2
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$tcp1 set fid_ 2
$tcp2 set fid_ 2
$tcp1 set packetsize_ 552
$tcp2 set packetsize_ 552

#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2


# Setup a UDP connection for udp flooding
set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]
set udp3 [new Agent/UDP]
set udp4 [new Agent/UDP]
$ns attach-agent $n(10) $udp1
$ns attach-agent $n(11) $udp2
$ns attach-agent $n(12) $udp3
$ns attach-agent $n(13) $udp4
set sink1 [new Agent/Null]
$ns attach-agent $n(14) $sink1
$ns connect $udp1 $sink1
$ns connect $udp2 $sink1
$ns connect $udp3 $sink1
$ns connect $udp4 $sink1
$udp1 set fid_ 1
$udp2 set fid_ 1
$udp3 set fid_ 1
$udp4 set fid_ 1

#setup CBR over UBP
set cbr1 [new Application/Traffic/CBR]
set cbr2 [new Application/Traffic/CBR]
set cbr3 [new Application/Traffic/CBR]
set cbr4 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr2 attach-agent $udp2
$cbr3 attach-agent $udp3
$cbr4 attach-agent $udp4

#Schedule events for the CBR and FTP agents
$ns at 1.5 "$cbr1 start"
$ns at 2.0 "$cbr2 start"
#$ns at 2.0 "$cbr3 start"
#$ns at 2.5 "$cbr4 start"
$ns at 0.0 "$ftp1 start"
$ns at 10.0 "$ftp1 stop"
$ns at 0.0 "$ftp2 start"
$ns at 10.0 "$ftp2 stop"
$ns at 10.0 "$cbr1 stop"
$ns at 10.0 "$cbr2 stop"
#$ns at 10.0 "$cbr3 stop"
#$ns at 10.0 "$cbr4 stop"

#Call the finish procedure after 10 seconds of simulation time
$ns at 10.0 "finish"

#Run the simulation
$ns run

