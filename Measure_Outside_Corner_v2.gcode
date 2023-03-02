(name,Measure Outside Corner v2)
;20230226 CSt from /Machine/Measure/Measure Outside Corner to make it run with conductive xy-adapter instead of active xy-probe
;20230227 CSt solve the issue with probe_size and offset value

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Measure Outside Corner v2)
(dlg,before START place mill above conductive probe => sets Origin for mill center right above DUT corner, typ=label, x=0, w=600, color=cccccc)
(dlg,Select corner, typ=label, x=20, w=455, color=0xffa500)
(dlg,data::MeasureCornerOutside, typ=image, x=0)
(dlg,|X+Y+|X+Y-|X-Y-|X-Y+, typ=checkbox, x=50, w=110, def=1, store, param=corner)
;(dlg,Distance from X edge, x=50, dec=1, def='setunit(10, 0.5);', min=0.1, max=10000, setunits, store, param=edge)
(dlg,Probe dimension, x=50, dec=1, def='setunit(5, 0.5);', min=0, max=100, setunits, store, param=w_probe)
(dlg,d_mill, x=50, dec=2, def='setunit(5.97, 1);', min=0.5, max=12, setunits, store, param=d_mill)
(dlg,Action|Measure|Set WO, typ=checkbox, x=0, w=90, def=2, store, param=action)
(dlg,Action|Clear, typ=checkbox, x=0, w=90, def=2, store, param=my_clear)
(dlgshow)

o<chk> if[#<my_clear> EQ 1]
  (clear) 
o<chk> endif


(print,|!Measure Outside Corner v2)
(print,=====================================)
(print, ) 

;######## globale variables for sizings & offstes so p110 und p131 work without active xy-probe #########
#<_probe_length> = 0
#<_probe_swdist> = 0.5
#<_probe_trav> = 3 ; distance mill gets lowered below detected z-edge for xy-probing 

#<_probe_sizex> = [#<d_mill>/2]
#<_probe_sizey> = [#<d_mill>/2]
#<save_probe_sizez> = #<_probe_sizez>
#<_probe_sizez> = 0

#<_probe_off_axis|0> = 0
#<_probe_off_axis|1> = 0
#<_probe_off_axis|2> = 0

#<edge> = 10  ;edge not needed as variable from GUI; set hard coded to 10


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
          #<corr_y> = 1
o<st> elseif [#<corner> EQ 2]
          #<axis> = 1
          #<dir> = -1
          #<corr_x> = 1
          #<corr_y> = -1
o<st> elseif [#<corner> EQ 3]
          #<axis> = 0
          #<dir> = -1
          #<corr_x> = -1
          #<corr_y> = -1
o<st> elseif [#<corner> EQ 4]
          #<axis> = 1
          #<dir> = +1
          #<corr_x> = -1
          #<corr_y> = 1
o<st> else
  (msg,Error)
  M2
o<st> endif

#<startz> = #<_machine_z>

G65 P145 H#<axis> E#<dir> D#<edge>

;########### Compensate Probe dimension reusing code from p103 ####################
#<posx> = [#<_measure_x> + #<corr_x> * #<w_probe>]
#<posy> = [#<_measure_y> + #<corr_y> * #<w_probe>]

#<offwx> = [#<posx> - #<_coordsys_x>]
#<offwy> = [#<posy> - #<_coordsys_y>]

(txt,cmd_setworkoffset,G92.1 X#<offwx> Y#<offwy>)
;##################################################################################

o<act> if [#<action> EQ 2]
          G04 P2  ;2s Delay, without work_offset will not be applied correctly
          $<cmd_setworkoffset>
o<act> endif

;reset to original z-probe-size so that future measure length works correct 
#<_probe_sizez> = #<_save_probe_sizez>

M2
