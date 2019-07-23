# important parameters for wireless network
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     17                         ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      1000                       ;# X dimension of topography
set val(y)      600                        ;# Y dimension of topography
set val(stop)   25.0                       ;# time of simulation end

#Phy/WirelessPhy set Pt_ 0.031622777
#Phy/WirelessPhy set bandwidth_ 11Mb
Mac/802_11 set dataRate_ 11Mb
Mac/802_11 set basicRate_ 1Mb

#Phy/WirelessPhy set freq_ 2.472e9

#Phy/WirelessPhy set CPThresh_ 5.011872e-12
#Phy/WirelessPhy set CSThresh_ 5.011872e-12
#Phy/WirelessPhy set L_ 1.0
#Phy/WirelessPhy set RXThresh_ 5.82587e-09


#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the trace file
set tracefile [open AODV.tr w]
$ns trace-all $tracefile
$ns use-newtrace

set tracefile [open AODV.txt w]
$ns trace-all $tracefile
$ns use-newtrace

#Open the nam-trace file
set namfile [open AODV.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel


# node configration
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON



#Create 17 nodes
set n0 [$ns node]
$n0 set X_ 199
$n0 set Y_ 443
$ns initial_node_pos $n0 20

set n1 [$ns node]
$n1 set X_ 361
$n1 set Y_ 432
$ns initial_node_pos $n1 20

set n2 [$ns node]
$n2 set X_ 363
$n2 set Y_ 287
$ns initial_node_pos $n2 20

set n3 [$ns node]
$n3 set X_ 210
$n3 set Y_ 271
$ns initial_node_pos $n3 20

set n4 [$ns node]
$n4 set X_ 246
$n4 set Y_ 139
$ns initial_node_pos $n4 20

set n5 [$ns node]
$n5 set X_ 402
$n5 set Y_ 141
$ns initial_node_pos $n5 20

set n6 [$ns node]
$n6 set X_ 499
$n6 set Y_ 261
$ns initial_node_pos $n6 20

set n7 [$ns node]
$n7 set X_ 564
$n7 set Y_ 418
$ns initial_node_pos $n7 20

set n8 [$ns node]
$n8 set X_ 609
$n8 set Y_ 292
$ns initial_node_pos $n8 20

set n9 [$ns node]
$n9 set X_ 542
$n9 set Y_ 115
$ns initial_node_pos $n9 20

set n10 [$ns node]
$n10 set X_ 370
$n10 set Y_ 41
$ns initial_node_pos $n10 20

set n11 [$ns node]
$n11 set X_ 688
$n11 set Y_ 156
$ns initial_node_pos $n11 20

set n12 [$ns node]
$n12 set X_ 758
$n12 set Y_ 316
$ns initial_node_pos $n12 20

set n13 [$ns node]
$n13 set X_ 728
$n13 set Y_ 428
$ns initial_node_pos $n13 20

set n14 [$ns node]
$n14 set X_ 695
$n14 set Y_ 54
$ns initial_node_pos $n14 20

set n15 [$ns node]
$n15 set X_ 556
$n15 set Y_ 21
$ns initial_node_pos $n15 20

set n16 [$ns node]
$n16 set X_ 856
$n16 set Y_ 188
$ns initial_node_pos $n16 20

#labelling
$ns at 0.0 "$n4 label CLIENT"
$ns at 0.0 "$n16 label SERVER"
$ns at 0.0 "$n6 label NORMAL_ROUTER"

#create a attacker node
#$ns at 1.0 "[$n2 set ragent_] blackhole"
$ns at 1.0 "[$n6 set ragent_] blackhole"
$ns at 1.0 "$n6 label BECOMES_ATTACKER"

#create moments
$ns at 1.0 " $n2 setdest 500 300 10 " 
$ns at 10.0 " $n2 setdest 600 500 30 " 
$ns at 2.0 " $n9 setdest 363 287 30 " 
$ns at 8.0 " $n9 setdest 695 54 25 " 



#Setup a UDP connection
#set udp0 [new Agent/UDP]
#$ns attach-agent $n3 $udp0
#set sink2 [new Agent/Null]
#$ns attach-agent $n12 $sink2
#$ns connect $udp0 $sink2
#$udp0 set packetSize_ 1500

#Setup a UDP connection
set udp1 [new Agent/UDP]
$ns attach-agent $n4 $udp1
set sink3 [new Agent/Null]
$ns attach-agent $n16 $sink3
$ns connect $udp1 $sink3
$udp1 set packetSize_ 1500

#set cbr0 [new Application/Traffic/CBR]
#$cbr0 attach-agent $udp0
#$ns at 1.0 "$cbr0 start"
#$ns at 15.0 "$cbr0 stop"

#setup CBR over UDP
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$ns at 0.0 "$cbr1 start"
$ns at 20.0 "$cbr1 stop"

#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam AODV.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run



