# Mekanika-PlanetCNC-UserCmd
User Commands for probing in PlanetCNC on a Mekanika EVO-M

**Disclaimer**: \
The code in this repository is tested on my Mekanika EVO-M. Situations on other users machines might be slightly different, which can cause heavy demage and severe injuries if the code doesn't get adopted accordingly. Don't run the code without having fully understood what it does and proper adoption of all variable-values to the specific situations on your machine. The author doesn't take any responsibility for any damage caused by mis-usage of the code!

**Intention of this Repository**:\
Mekanika EVO only comes with a Z-probe for semi-automated tool length measurement.\
Out of the box there is no XY-probing feature that would allow to run PlanetCNC's measurement scripts for automatic finding of edges, corners or the center of holes and protrusions.
Without these XY-features setting the origin of the work coordinate system with high precision is a cumbersome task and prone to human error.\

In general the feature set of  PlanetCNC's  controller board  Mk3/4  which is used in Mekanika EVO would support an active XY-probe. But VDD is not routed from the board to the probe connector socket on the back of the control unit. It would be an easy task to upgrade this connector, but the control unit is sealed for warranty. Opening the unit  would sacrifice warranty!

For those who want to keep their warranty but don't want to miss the XY-probing features there is a workaround re-using the Z-probe for XY-probing. 

And this is how it works:
Basically every milling tool can be re-used for this method, but for better accuracy and repeatability it's recommended to insert a perfectly rounded steel rod and connect it to the probe as you would do for z-probing. After that you flip the probe around a horizontal axis and position it snug against the edge to be probed (see Fig. 4) For good accuracy it's recommended to support the Z-probe  manually against the edge as long as the measurement is running. Feel free to use whatever sort of clamping you think is appropriate but never let the probe unsupported.
Now it would theoretically be possible to use the script “Edge Position”  from  menu Machine/Measure  straight out of the box. But before you can do so several parameters in menu File/Settings/Probe & Measure would need to be adapted carefully to achieve correct results. This requires full understanding of what is going on in sub-routines o110 and o130. 
If you feel uncomfortable with those parameters or want to run other XY-measurement scripts without spending thoughts about re-configuring  this parameter-set  again and again there is an enhanced version of the script “Edge Position”. It  asks for the rod's diameter and the probe height upfront in the pop-up GUI and sets the Probe& Measure parameters to enable full full re-use of PlanetCNC's sub-routines. This results in work coordinates with the origin straight above the edge.



Videos showing the script in action can be found on YouTube.
