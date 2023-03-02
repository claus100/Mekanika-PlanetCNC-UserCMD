(name,ProbeEdgeWith_Zprobe_v4)
; 20230220 Cst ... re-use zProbe to probe edges in X & Y; modified from the script /Machine/Measure/EdgePoistion 
;                  for correct results mill-diameter and probe-height need to be entered correctly in GUI
;                  script needs to be copied to PlanetCNC/Profiles/myProfile/UserCmd
;20230222 CSt v2 fixed remeber start-position of not probed axis
;20230225 CSt v3, v4 adopt learnings about scripts 

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Probe Edge with Zprobe v4)
(dlg, Findes position of edge below the mills center, typ=label, x=0, w=500, color=0x909090)
(dlg,Select start postition, typ=label, x=20, color=0xffa500)
(dlg,data::MeasureAxis, typ=image, x=0)
(dlg,|X+|X-|Y+|Y-, typ=checkbox, x=50, w=110, def=1, store, param=orient)
(dlg,z-Probe height, x=30, dec=2, def='setunit(19.2, 0.5);', min=0, max=100, setunits, store, param=h_zprobe)
(dlg,d_mill, x=30, dec=2, def='setunit(5.97, 1);', min=0.5, max=12, setunits, store, param=d_mill)
(dlg,search distance, x=30, dec=0, def='setunit(20, 0.5);', min=10, max=50, setunits, store, param=s_search)
(dlg,Action|Measure|Set WO, typ=checkbox, x=30, w=90, def=2, store, param=action)
(dlg,Action|Clear, typ=checkbox, x=30, w=90, def=2, store, param=my_clear)
(dlgshow)

o<chk> if[#<my_clear> EQ 1]
  (clear)
o<chk> endif

(print, ProbeEdgeWith_Zprobe v3 by Claus Stoeger)
(print, ========================================)
(print, ) 


M73
G17 G90 G91.1 G90.2 G08 G15 G94
M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

o<st> if [#<orient> EQ 1]
  #<axis> = 0
  #<dir> = +1
o<st> elseif [#<orient> EQ 2]
  #<axis> = 0
  #<dir> = -1
o<st> elseif [#<orient> EQ 3]
  #<axis> = 1
  #<dir> = +1
o<st> elseif [#<orient> EQ 4]
  #<axis> = 1
  #<dir> = -1
o<st> else
  (msg,Error)
  M2
o<st> endif

;############# remember start-position  #####
#<x_start> = #<_machine_x> 
#<y_start> = #<_machine_y> 
;############################################

;set global variable for return distance after probe conatct in G38
#<_probe_swdist> = 0.5 
;set correctionvalue for probe-thickness and half mill-size
#<l_correct> = [#<h_zprobe> + #<d_mill>/2]

G65 P110 H#<axis> E#<dir> D#<s_search> J#<l_correct> R1
G65 P102 H#<axis>


o<act> if [#<action> EQ 2]
           G04 P2  ;2s Delay, without work_offset will not be applied correctly
           $<cmd_setworkoffset>
o<act> elseif [#<action> EQ 1] 
         (print,|!    Edge: #<pos>  ) 
o<act> endif


M02


