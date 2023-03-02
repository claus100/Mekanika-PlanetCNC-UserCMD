(name,MeasureProtrusion_v3)
;20230225 CSt from /Machine/Measure/MeasureProtrusion to allow measure conductive protrusion without XY-Probe 

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Measure Protrusion v3)
(dlg,Select start postition, typ=label, x=20, color=0xffa500)
(dlg,data::MeasureProtrusion, typ=image, x=60)
(dlg,Protrusion size, typ=label, x=20, color=0xffa500)
(dlg,Size X, x=0, dec=1, def='setunit(5.9, 1);', min=0.1, max=100, setunits, store, param=sizex)
(dlg,Size Y, x=0, dec=1, def='setunit(5.9, 1);', min=0.1, max=100, setunits, store, param=sizey)
(dlg,d_mill, x=0, dec=2, def='setunit(5.97, 1);', min=0.5, max=12, setunits, store, param=d_mill)
(dlg,Action|Measure|Move|Set WO, typ=checkbox, x=0, w=90, def=3, store, param=action)
(dlg,Action|Clear, typ=checkbox, x=0, w=90, def=2, store, param=my_clear)
(dlgshow)

o<chk> if[#<my_clear> EQ 1]
  (clear)
o<chk> endif


(print,|!Measure Protusion )
(print, =====================================)
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


M73
G17 G08 G15 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1
M11P1

#<startz> = #<_machine_z>

G65 P156 I#<sizex> J#<sizey>

o<act> if [#<action> EQ 2]
         G53 G00 Z#<startz>
         $<cmd_moveto>
o<act> elseif [#<action> EQ 3]
         G04 P2  ;2s Delay, without work_offset will not be applied correctly
         $<cmd_setworkoffset>
o<act> endif

;reset to original z-probe-size so that future measure length works correct 
#<_probe_sizez> = #<_save_probe_sizez>

M2
