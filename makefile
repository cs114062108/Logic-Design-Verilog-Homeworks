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
src2_2 = HW2_SRLatch.v HW2_DLatch.v HW2_DFF.v HW2_2_tb0.v
v2_2 = $(patsubst %, HW2/%, $(src2_2))

src3_0 = mod.v tb0.v
pre3_0 = HW3_114062108
v3_0 = $(patsubst %, HW3/$(pre3_0)_%, $(src3_0))

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
vvp2_2 = $(vvpdir)/HW2_2.vvp
$(vvp2_2): $(v2_2)

vvp3_0 = $(vvpdir)/HW3_0.vvp
$(vvp3_0): $(v3_0)

vvp_hz0_1a = $(vvpdir)/HZ0_1a.vvp
$(vvp_hz0_1a): $(v_hz0_1a)

# --- Targets ---
.PHONY: clean hw0_1a hw0_2a hw1_0 hw1_1 hw2_1 hw2_2 hw3_0 hazard0_1a

hw0_1a: hw0_1a_com hw0_1a_sim
hw0_1a_com: $(vvp0_1a)
hw0_1a_sim: run-HW0_1a

hw0_2a: hw0_2a_com hw0_2a_sim
hw0_2a_com: $(vvp0_2a)
hw0_2a_sim: run-HW0_2a

hw1_0: hw1_0_com hw1_0_sim
hw1_0_com: $(vvp1_0)
hw1_0_sim: run-HW1_0

hw1_1: hw1_1_com hw1_1_sim
hw1_1_com: $(vvp1_1)
hw1_1_sim: run-HW1_1

hw2_1: hw2_1_com hw2_1_sim
hw2_1_com: $(vvp2_1)
hw2_1_sim: run-HW2_1

hw2_2: hw2_2_com hw2_2_sim
hw2_2_com: $(vvp2_2)
hw2_2_sim: run-HW2_2

hw3_0: hw3_0_com hw3_0_sim
hw3_0_com: $(vvp3_0)
hw3_0_sim: run-HW3_0

hazard0_1a: hz0_1a_com hz0_1a_sim
hz0_1a_com: $(vvp_hz0_1a)
hz0_1a_sim: run-HZ0_1a

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
