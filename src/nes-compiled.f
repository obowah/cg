( NES-150 )

: HEADLINE ( -- )
  31 spaces ."            Part       Parts      Time       Labor      Sell "                                
  cr ;

: RISER-100A ( - )
  [ electric  ] keyboard on kclr   cr
1 [ SETUP     ] ." Setup"  hot-220 cr
1 [ RISER cr  ] ." Riser"  100A    cr
1 [ 90-INC cr ] ." 90-inc" 100A    cr
1 [ LB-INC cr ] ." LB-inc" 100A    cr
headline total ;

: RISER-125A ( - )
  electric keyboard on kclr
1 [ RISER remvoc ] 125A    cr
1 [ 90-INC remvoc ] 125A    cr
1 [ LB-INC remvoc ] 125A    cr
headline total ;

: RISER-150A ( - )
  electric keyboard on kclr
1 [ RISER  ] 150A    cr
1 [ 90-INC ] 	150A   cr
1 [ LB-INC ] 	150A   cr
headline total ;

: RISER-200A ( - )
  electric keyboard on kclr
1 [ RISER  ] 200A  cr
1 [ 90-INC ] 200A  cr
1 [ LB-INC ] 200A  cr
         total ;

: NES-150A ( 150A 2 meter New Service )
( SETUP 	HOT-202     edfined but it is there )
  electric keyboard on kclr         cr
1 [ setup   ] ." Setup"  job        cr
1 [ RISER   ] ." Riser"  	150A      	cr
1 [ 90-INC  ] ." 90-inc" 	150A      cr	
2 [ LB-INC  ] ." LF-inc" 	150A      cr
1 [ METER   ] ." Meter"  2-gang     cr
2 [ OS-NIP  ] ." OS-Nip" 	100A      cr
1 [ PANEL   ] ." Panel"  125A-12-24 cr
1 [ C-B     ] ." CB"     	100A      	cr
1 [ GROUND  ] ." Ground Bond" 	BOND      cr
1 [ GROUND  ] ." Ground"  	150A      cr
         total ;

\ permit  riser  meter-main or meter-panel  grounding  reconnections

: NES-100A  ( -- )
  electric keyboard on kclr            CR
1  [ permit ] ." permit" PANEL-CHANGE   
1  [ riser ] ( not needed )
                   RISER-100A  CR \ the part name comes from prior
1  [ METER-RT ]    100A                CR
1  [ C-B ]         100A                CR
1  [ PANEL ]       150a-16-32          CR
3  [ RECONNECT ]   1/2                 CR
1  [ RECONNECT ]   6-LOOM-N&T          CR
1  [ GROUND ]      BOND                CR
1  [ GROUND ]      ROD                 CR
HEADLINE TOTAL ;

\ Permit  riser  meter-main or meter-panel  grounding  reconnections



: RISER-100A  108.23 w/e 528 c ;

\s   Below are for copy-paste into the console for immediate interpreting.

1 RISER-100A
1 METER-RT  100A
1 C-B       100A
1 PANEL     150a-16-32
3 RECONNECT 1/2
1 RECONNECT 6-LOOM-N&T
1 GROUND    BOND
1 GROUND    ROD
1 PERMIT PANEL-CHANGE
Total  cr cr

cr 1 RISER-100A


cr 1 METER-RT  100A
cr 1 C-B       100A
cr 1 PANEL     150a-16-32
cr 3 RECONNECT 1/2
cr 1 RECONNECT 6-LOOM-N&T
cr 1 GROUND    BOND
cr 1 GROUND    ROD
cr 1 PERMIT PANEL-CHANGE
cr Total  cr cr
