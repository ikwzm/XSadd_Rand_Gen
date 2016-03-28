GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=XSADD

TEST_BENCH = test_bench \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

test_bench: xsadd.o xsadd_rand_gen.o test_bench.o 
	 $(GHDL) -e $(GHDLFLAGS) $@
	-$(GHDL) -r $(GHDLRUNFLAGS) $@

test_bench.o:      ../../src/test/vhdl/test_bench.vhd xsadd_rand_gen.o
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

xsadd.o:           ../../src/main/vhdl/xsadd.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

xsadd_rand_gen.o:  ../../src/main/vhdl/xsadd_rand_gen.vhd xsadd.o
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

