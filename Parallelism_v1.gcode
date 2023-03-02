  (name,Parallelism_v1)
;20230223 CSt check if DUT is parallel to x or y axis
;             re-uses p110 to find 1st corner on axis, moves 2nd-point-distance perpendicular to axis and re-uses p110 to find the edge again
;             calculates offset between the two edge conatct points

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Check Parallelism_v1)
(dlg,START: place mill next to 1st corner; does 2 measurements to check if DUT is parallel to axis, typ=label, x=0, w=500, color=909090)
(dlg,Select corner, typ=label, x=20, w=455, color=0xffa500)
(dlg,Icons/Parallelism_GUI.png, typ=image, x=30)
(dlg,|X+|Y+, typ=checkbox, x=50, w=110, def=1, store, param=corner)
(dlg,search distance, x=50, dec=0, def='setunit(30, 0.5);', min=10, max=50, setunits, store, param=d_search)  
(dlg,distance 2nd point, x=50, dec=0, def='setunit(200, 5);', min=1, max=1500, setunits, store, param=d_2nd)
(dlg,Probe thickness, x=50, dec=2, def='setunit(5, 0.5);', min=0, max=100, setunits, store, param=w_probe)
(dlg,d_mill, x=50, dec=2, def='setunit(5.97, 1);', min=0.5, max=12, setunits, store, param=d_mill)
(dlg,Action|Clear, typ=checkbox, x=0, w=90, def=0, store, param=my_clear)
(dlgshow)

o<chk> if[#<my_clear> EQ 1]
  (clear) 
o<chk> endif




(print,|!Parallelism_v1 )
(print,=====================================)
(print, ) 


M73
G17 G08 G15 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1

o<st> if [#<corner> EQ 1]
          #<axis> = 0
          #<dir> = +1
          #<corr_x> = 1
          #<corr_y> = 0
o<st> elseif [#<corner> EQ 2]
          #<axis> = 1
          #<dir> = 1
          #<corr_x> = 0
          #<corr_y> = 1
o<st> else
          (msg,Error)
          M2
o<st> endif

;############# remember start-position  #####
#<start_x> = #<_machine_axis|0> 
#<start_y> = #<_machine_axis|1> 
#<start_z> = #<_machine_axis|2  > 
;############################################
(print,|!  Machine coordinate Start:)
(print,  X#<start_x> Y#<start_y>)

;##### set global variable for return distance after probe conatct in G38
#<_probe_swdist> = 0.5 
;##### set correctionvalue for probe-thickness and half mill-size
#<l_correct> = [#<d_mill>/2]

;#########Search 1st edge ################
G65 P110 H#<axis> E#<dir> D#<d_search> J#<l_correct> R0
(print,|!  Machine coordinate 1st edge contact:)
(print,  X#<_measure_x> Y#<_measure_y>)

#<measure_1> = #<_measure_axis|#<axis>>

;##### Move to save travel hight ###########################################
#<travel_z> = [#<start_z> + 20] 
o<chk> if [#<travel_z> GT #<_motorlimit_zp>]
          #<travel_z> = [#<_motorlimit_zp> -1 ]     
o<chk> endif 
G53 G00 H2 E#<travel_z>

;#### return to start & check if 2nd measurement point is within machine limits #########
o<st> if [#<axis> EQ 0]
          #<d_return_x> = [#<_measure_axis|#<axis>> - #<start_x>]
          #<return_x> = [#<_measure_axis|#<axis>> - #<d_return_x>]
          G53 G01 H#<axis> E#<return_x>

          #<travel_y> = [#<start_y> + #<d_2nd>]
          (print,|!  Machine coordinate Y-travel & Y-Limit:)
          (print,  Y#<travel_y> L#<_motorlimit_yp>)

          o<chk> if [#<travel_y> GT #<_motorlimit_yp>]
                    (msg,Error: Y-limit exeeded)
                     M2
          o<chk> endif
          (msg, ATTENTION: Will move to Machine Position Y: #<travel_y>)
          G53 G01 H1 E#<travel_y>
o<st> elseif [#<axis> EQ 1]
             #<d_return_y> = [#<_measure_axis|#<axis>> - #<start_y>]
             #<return_y> = [#<_measure_axis|#<axis>> - #<d_return_y>]
             G53 G01 H#<axis> E#<return_y>

             #<travel_x> = [#<start_x> + #<d_2nd>]
             (print,|!  Machine coordinate X-travel & X-Limit:)
             (print,  X#<travel_x> #<_motorlimit_xp>)

             o<chk> if [#<travel_x> GT #<_motorlimit_xp>]
                    (msg,Error: X-limit exeeded)
                     M2
             o<chk> endif 
             (msg, ATTENTION: Will move to Machine Position X: #<travel_x>)
             G53 G01 H0 E#<travel_x>
o<st> endif

(msg, Re-Position Probe)
G53 G00 H2 E#<start_z>

;#########Search 2nd edge ################
G65 P110 H#<axis> E#<dir> D#<d_search> J#<l_correct> R1
(print,|!  Machine coordinate 2nd edge contact:)
(print,  X#<_measure_x> Y#<_measure_y>)

#<measure_2> = #<_measure_axis|#<axis>>

#<delta> = [#<measure_2> - #<measure_1>]
;#<delta> = round(#<delta>,2)

(print,  )
(print,  )
(print,|!  Delta between Edges:)
(print,  D#<delta>)
(print,  )
(print,  )


M2
