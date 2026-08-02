# -- Compiler and directory variables --
# Compilers
IV = iverilog
VP = vvp
GTK = gtkwave

# Directories
vvpdir = vvps
wavedir = waves

# -- Source declare --
# Verilog source files
v0_1a = HW0/HW0_1a.v HW0/HW0_1t.v
v0_2a = HW0/HW0_2a.v HW0/HW0_2t.v

src1_0 = HW1_adder.v HW1_4bit_cla.v HW1_8bit_cla.v HW1_tb0.v
v1_0 = $(patsubst %, HW1/%, $(src1_0))
src1_1 = HW1_adder.v HW1_4bit_cla.v HW1_8bit_cla.v HW1_tb1.v
v1_1 = $(patsubst %, HW1/%, $(src1_1))

v2_1 = HW2/HW2_demux.v HW2/HW2_1_tb0.v

v_hz0_1a = Hazard/Hazard0_1a.v Hazard/Hazard0_1t.v

# .vvp requirements
vvp0_1a = $(vvpdir)/HW0_1a.vvp
$(vvp0_1a): $(v0_1a)
vvp0_2a = $(vvpdir)/HW0_2a.vvp
$(vvp0_2a): $(v0_2a)

vvp1_0 = $(vvpdir)/HW1_0.vvp
$(vvp1_0): $(v1_0)
vvp1_1 = $(vvpdir)/HW1_1.vvp
$(vvp1_1): $(v1_1)

vvp2_1 = $(vvpdir)/HW2_1.vvp
$(vvp2_1): $(v2_1)

vvp_hz0_1a = $(vvpdir)/HZ0_1a.vvp
$(vvp_hz0_1a): $(v_hz0_1a)

# --- Targets ---
.PHONY: clean hw0_1a hw0_2a hw1_0 hw1_1 hazard0_1a

hw0_1a: hw0_1a_com hw0_1a_run
hw0_1a_com: $(vvp0_1a)
hw0_1a_run: run-HW0_1a

hw0_2a: hw0_2a_com hw0_2a_run
hw0_2a_com: $(vvp0_2a)
hw0_2a_run: run-HW0_2a

hw1_0: hw1_0_com hw1_0_run
hw1_0_com: $(vvp1_0)
hw1_0_run: run-HW1_0

hw1_1: hw1_1_com hw1_1_run
hw1_1_com: $(vvp1_1)
hw1_1_run: run-HW1_1

hw2_1: hw2_1_com hw2_1_run
hw2_1_com: $(vvp2_1)
hw2_1_run: run-HW2_1

hazard0_1a: hz0_1a_com hz0_1a_run
hz0_1a_com: $(vvp_hz0_1a)
hz0_1a_run: run-HZ0_1a

# -- Universal make logic --
# Compile pattern rule
$(vvpdir)/%.vvp: | $(vvpdir)
	@echo "==> Compiling $@"
	$(IV) -o $@ $^

# Simulation
run-%: $(vvpdir)/%.vvp | $(wavedir)
	@echo "==> Simulating $<"
	$(VP) $<

# Directories
$(vvpdir) $(wavedir):
	mkdir -p $@

# -- Clean --
clean:
	rm -rf $(vvpdir) $(wavedir)
