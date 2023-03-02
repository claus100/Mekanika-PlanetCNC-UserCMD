(name,Measure Inside Corner v2)
;20230226 CSt from /Machine/Measure/Measure Inside Corner to make it run with conductive xy-adapter instead of active xy-probe

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Measure Inside Corner v2)
(dlg,Set Origin so mill center is right above corner, typ=label, x=0, w=500, color=cccccc)
(dlg,Select corner, typ=label, x=20, w=155, color=0xffa500)
(dlg,data::MeasureCornerInside, typ=image, x=0)
(dlg,|X+Y+|X+Y-|X-Y-|X-Y+, typ=checkbox, x=50, w=110, def=3, store, param=corner)
(dlg,Probe thickness, x=30, dec=1, def='setunit(5, 0.5);', min=0, max=100, setunits, store, param=w_probe)
(dlg,d_mill, x=0, dec=2, def='setunit(5.97, 1);', min=0.5, max=12, setunits, store, param=d_mill)
(dlg,Action|Measure|Set WO, typ=checkbox, x=0, w=90, def=2, store, param=action)
(dlg,Action|Clear, typ=checkbox, x=0, w=90, def=2, store, param=my_clear)
(dlgshow)

o<chk> if[#<my_clear> EQ 1]
  (clear) 
o<chk> endif


(print,|!Measure Inside Corner v2)
(print,=====================================)
(print, ) 

;######## globale variables for sizings & offstes so p110 und p131 work without active xy-probe #########
#<_probe_swdist> = 0.5

#<_probe_sizex> = [#<w_probe> + #<d_mill>/2]
#<_probe_sizey> = [#<w_probe> + #<d_mill>/2]

#<_probe_off_axis|0> = 0
#<_probe_off_axis|1> = 0
#<_probe_off_axis|2> = 0


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
o<st> elseif [#<corner> EQ 2]
  #<axis> = 1
  #<dir> = -1
o<st> elseif [#<corner> EQ 3]
  #<axis> = 0
  #<dir> = -1
o<st> elseif [#<corner> EQ 4]
  #<axis> = 1
  #<dir> = +1
o<st> else
  (msg,Error)
  M2
o<st> endif

G65 P140 H#<axis> E#<dir>

o<act> if [#<action> EQ 2]
  G04 P2  ;2s Delay, without work_offset will not be applied correctly
  $<cmd_setworkoffset>
o<act> endif

M2
