# GRBL Parser Library in Ada

A parser for output (!) messages from GRBL.

You typically send GRBL code - often called G code - via a sender
program to a (micro)controller running a GRBL interpreter. The most
famous one also called [`grbl`](https://github.com/grbl/grbl). It is
quite old by now and several successors emerged, notably
[`grblHAL`](https://github.com/grblHAL) and [`FluidNC`](http://wiki.fluidnc.com/en/home).

When a controller receives messages from a G code sender it responds
with the so called [line
protocol](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Interface). This
library is a parser for the controller responses.


