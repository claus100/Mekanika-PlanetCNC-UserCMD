# Mekanika-PlanetCNC-UserCmd
User Commands for probing in PlanetCNC running on a Mekanika EVO-M

**Disclaimer**: 
The code in this repository is tested on my Mekanika EVO-M. Situations on other users machines might be slightly different, which can cause heavy demage on your machnine if the code is not adopted accordingly. Don't run the code without having fully understood what it does and proper adoption of all variable-values to the specific situations on your machine. The author doesn't take any responsibility for any damage caused by mis-usage of the code.

**Intention of this Repository**:
Mekanika EVO only comes with a Z-probe for tool length measurement. 
Out of the box there is no XY-probing feature that would allow to find edges, corners or the center of holes and protrusions.
In principle the PlanetCNC Mk3/4 controller board of the Mekanika EVO would support active XY-probes.
But VDD and GND are not routed to the hardwired probe connector of the control unit box.
It would be very easy to upgrade this connector, but the Mekanika control unit  is sealed for warranty. Opening the unit  to get access to the relevant pins of the control board would sacrifice the warranty? 

For those who want to keep their warranty but won't miss y XY-probing feature there is a simple workaround to re-use the Z-probe for some sort of “poor man's” XY-probing. 
The corresponding scripts provided in PlanetCNCs menue "Machine/Measure" need to be slightly adopted for proper handling of the changed offset situation. All the underlying sub-routines can be fully re-used.

Videos showing the script in action can be found on YouTube.
