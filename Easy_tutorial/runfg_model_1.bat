C:
cd C:\Program Files\FlightGear 2020.1.3

SET FG_ROOT=C:\Program Files\FlightGear 2020.1.3\data
.\\bin\fgfs --aircraft=c172p --fdm=network,localhost,5501,5503,5503 --multiplay=out,10,127.0.0.1,5000 --multiplay=in,10,127.0.0.1,5001 --callsign=Test1 --fog-fastest --disable-clouds --start-date-lat=2004:06:01:09:00:00 --disable-sound --in-air --enable-freeze --airport=KSFO --runway=10L --altitude=7224 --heading=113 --offset-distance=4.72 --offset-azimuth=0 --prop:/sim/rendering/shaders/quality-level=0
