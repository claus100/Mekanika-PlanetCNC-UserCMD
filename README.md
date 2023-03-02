# Mekanika-PlanetCNC-UserCmd
User Commands for PlanetCNC running on a Mekanika EVO-M

Mekanika only comes with a Z-probe that allows to consider correct tool length in the work coordinate system.
But unfortunately there is no XY-probing feature that would allow to find corners , edges, the center of holes or protrusions.
 It's not possible to connect  active XY-probes to the connector of the Z-probe because it does not provide VDD and GND.
In general the PlanetCNC Mk3/4 controller board of the Mekanika EVO would be able to support an active XY-probe in parallel to the Z-probe.
But the Mekanika control unit  is sealed for warranty. Opening the unit  to get access to the relevant pins of the control board would sacrifice the warranty ? 
But there is a simple workaround to re-use the Z-probe for some sort of “poor man's” XY-probe. The corresponding scripts in /Machine/Measure need to be slightly adopted to properly handle the changed offsets. But all the underlying o-scripts provided by PlanetCNC can be fully re-used.
The user command can be found on GitHub.
A video showing the script in action can be found on YouTube.
