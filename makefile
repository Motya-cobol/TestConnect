SHELL := /bin/bash 
TEMPS=tmps
COBC=cobcd 
# default options, note that -g will leave intermediate files
# add -fdebugging-line flag to display debugging messages that were commented with D.
# To Add support for tracing -ftrace and -ftraceall.
#COBCOPTS = -g -debug -static -v -Wall -O -L/home/db2inst1/sqllib/lib64 -L/usr/local/lib -I/home/db2inst1/sqllib/include/cobol_mf -ldb2 --save-temps=tmps
COBCOPTS = -g -debug -static -v -Wall -O -L/home/db2inst1/sqllib/lib64 -I/home/db2inst1/sqllib/include/cobol_mf -ldb2 --save-temps=$(TEMPS)

all: | $(TEMPS) demo check_err_fn.o connect_fn.o read_fn.o

$(TEMPS):
	mkdir -p $@
#remove all temp files
clean:	
	echo "Removing all binding and precompile files: *.i  *.o *.lst *.bnd .c *.h *.cbl"
	rm demo *.cbl *.bnd *.lst
	rm tmps/*

demo: check_err_fn.o connect_fn.o read_fn.o main.o
	$(COBC) $(COBCOPTS) -x $(TEMPS)/main.o $(TEMPS)/connect_fn.o $(TEMPS)/check_err_fn.o $(TEMPS)/read_fn.o -o demo

check_err_fn.o: check_err_fn.cob check_err_fn.cpy
	$(COBC) $(COBCOPTS) -c check_err_fn.cob -t check_err_fn.lst 	

connect_fn.o: connect_fn.sqb connect_fn.cpy check_err_fn.cpy
	db2 -tvf precompile_connect_fn.sql
	$(COBC) $(COBCOPTS) -c connect_fn.cbl -t connect_fn.lst

read_fn.o: read_fn.sqb read_fn.cpy check_err_fn.cpy
#regular users don't have any privileges for accessing TABLES of SAMPLE db2inst1 installation
# did grant ALL to PUBLIC, don't know how to grant a specific linux user privileges 
# First connect with admin privileges: db2 connect to sample user db2inst1 using ACIDdb2	
#	db2 GRANT SELECT ON db2inst1.EPLOYEE TO PUBLIC	
	db2 -tvf precompile_read_fn.sql
	$(COBC) $(COBCOPTS) -c read_fn.cbl -t read_fn.lst

main.o: main.cob read_fn.cpy check_err_fn.cpy
	$(COBC) $(COBCOPTS) -c -x main.cob -t main.lst