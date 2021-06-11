SHELL := /bin/bash 
TEMPS = tmps
COBC = cobcd 
# default options, note that -g will leave intermediate files
# add -fdebugging-line flag to display debugging messages that were commented with D.
# To Add support for tracing -ftrace and -ftraceall.
COBCOPTS = -g -debug -static -v -Wall -O -L/home/db2inst1/sqllib/lib64 -I/home/db2inst1/sqllib/include/cobol_mf -ldb2 --save-temps=$(TEMPS)
COPYBOOKS = $(wildcard *.cpy)

all: $(TEMPS) demo
$(TEMPS):
	mkdir -p $@

# rules for .sqb-> .o
sqb_srcs = $(wildcard *.sqb)
_sqb_objs = $(sqb_srcs:.sqb=.o)
sqb_objs = $(patsubst %,$(TEMPS)/%,$(_sqb_objs))

$(TEMPS)/%.o: %.sqb $(COPYBOOKS)
	echo "Making $@ from $<"
	db2 connect to sample
	db2 prep $< bindfile target ANSI_COBOL
	db2 bind $(patsubst %.sqb,%.bnd,$<)
	db2 connect reset
	$(COBC) $(COBCOPTS) -c $(patsubst %.sqb,%.cbl,$<) -t $(patsubst %.sqb,%.lst,$<)

# rules for .cob-> .o
cob_srcs = $(wildcard *.cob)
_cob_objs = $(cob_srcs:.cob=.o)
cob_objs = $(patsubst %,$(TEMPS)/%,$(_cob_objs))

$(TEMPS)/%.o: %.cob $(COPYBOOKS)
	$(COBC) $(COBCOPTS) -c $< -t $(patsubst %.cob,%.lst,$<)

# rule for the main() cobol file.
# Should be only one file with extension *.cbm
# main COBOL file should be compliled with both -c and -x flags
cbm_srcs = $(wildcard *.cbm)
_cbm_objs = $(cbm_srcs:.cbm=.o)
cbm_objs = $(patsubst %,$(TEMPS)/%,$(_cbm_objs))

$(TEMPS)/%.o: %.cbm $(COPYBOOKS)
	$(COBC) $(COBCOPTS) -c -x $< -t $(patsubst %.cbm,%.lst,$<)

# linking to make demo
demo: $(sqb_objs) $(cob_objs) $(cbm_objs)
	echo "Linking up $(sqb_objs) $(cob_objs) $(cbm_objs)"
	$(COBC) $(COBCOPTS) -x $^ -o $@

#Clean up
.PHONY: clean

clean:	
	echo "Removing all binding and precompile files: *.i  *.o *.lst *.bnd .c *.h *.cbl"
	rm $(TEMPS)/*
	rmdir $(TEMPS)
	rm demo *.cbl *.bnd *.lst