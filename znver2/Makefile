# Compiler settings - Can be customized.
FC ?= gfortran
FFLAGS ?= -O2 -g
LDFLAGS ?= -lm

# Program name
PROGRAM ?= gfortran_toy.exe

# Object files
OBJS = INTERFACE_ARRAY.o INITIALISE.o

# Rules
all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(FC) $(FFLAGS) -o $@ TOYPROBLEM.F90 $^ $(LDFLAGS)

%.o: %.F90
	$(FC) $(FFLAGS) -c $<

# Phony targets for clean-up and others
.PHONY: clean

clean:
	rm -f $(PROGRAM) $(OBJS) *.mod
