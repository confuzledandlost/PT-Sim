msg="\n\n\#\#\n\#\#\n\#\# This file was generated by a script. Don't edit it.\n\#\#\n\#\#"



# 1. Create new targets for your executables
# 2. Modify pt-sim.sh and pt-sim-clock.sh
#    so it calls the appropriate executable
# 3. Include the relevant target in the list
#    of dependencies for each of pt-sim
#    and pt-sim-aging

all: ptsim ptsim-clock

ptsim: pt-sim.sh
	cp pt-sim.sh ptsim
#	@echo -e ${msg} >> ptsim

ptsim-clock: pt-sim-clock.sh
	cp pt-sim-clock.sh ptsim-clock
#	@echo -e ${msg} >> ptsim-clock

clean:
	rm -f ptsim ptsim-clock
