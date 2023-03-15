# Mekanika-PlanetCNC-UserCmd
User Commands for probing in PlanetCNC on a Mekanika EVO-M

**Disclaimer**: \
The code in this repository is tested on my Mekanika EVO-M. Situations on other users machines might be slightly different, which can cause heavy demage and severe injuries if the code doesn't get adopted accordingly. Don't run the code without having fully understood what it does and proper adoption of all variable-values to the specific situations on your machine. The author doesn't take any responsibility for any damage caused by mis-usage of the code!

**Intention of this Repository**:\
Mekanika EVO only comes with a Z-probe for semi-automated tool length measurement.\
Out of the box there is no XY-probing feature that would allow to run PlanetCNC's measurement scripts for automatic finding of edges, corners or the center of holes and protrusions. Without these XY-features setting the origin of the work coordinate system with high precision is a cumbersome task and prone to human error.

In general the feature set of  PlanetCNC's controller board Mk3/4  which is used in Mekanika EVO would support an active XY-probe. But VDD is not routed from the board to the probe connector socket on the back of the control unit. It would be an easy task to upgrade this connector, but the control unit is sealed for warranty. Opening the unit  would sacrifice warranty!

For those who want to keep their warranty but don't want to miss the XY-probing features there is a workaround by  re-using the Z-probe for XY-probing or even enhancing it with a parallel measurement loop equipped with conductive probing adapter. 

Videos showing those scipts in action can be found on [my YouTube channlel](https://www.youtube.com/@CStech.)

In the future ther will probably be detailed articles about this Methodology on Mekanika's home page.
