vvpdir = vvps
wavedir = waves

IV = iverilog
VP = vvp
GTK = gtkwave

hw0_1a: hw0_1a_com hw0_1a_wave
v0_1a = HW0/HW0_1a.v HW0/HW0_1t.v
vvp0_1a = $(vvpdir)/HW0_1a.vvp
hw0_1a_com: $(v0_1a) | $(vvpdir)
	$(IV) -o $(vvp0_1a) $^
wave0_1a = $(wavedir)/HW0_1.vcd
hw0_1a_wave: $(vvp0_1a) | $(wavedir)
	$(VP) $^

hw0_2a: hw0_2a_com hw0_2a_wave
v0_2a = HW0/HW0_2a.v HW0/HW0_2t.v
vvp0_2a = $(vvpdir)/HW0_2a.vvp
hw0_2a_com: $(v0_2a) | $(vvpdir)
	$(IV) -o $(vvp0_2a) $^
wave0_2a = $(wavedir)/HW0_2.vcd
hw0_2a_wave: $(vvp0_2a) | $(wavedir)
	$(VP) $^

hw1_0: hw1_0_com hw1_0_wave
src1_0 = HW1_adder.v HW1_4bit_cla.v HW1_8bit_cla.v HW1_tb0.v
v1_0 = $(patsubst %, HW1/%, $(src1_0))
vvp1_0 = $(vvpdir)/HW1_0.vvp
hw1_0_com: $(v1_0) | $(vvpdir)
	@echo [Homework 1 compile]
	$(IV) -o $(vvp1_0) $^
wave1_0 = $(wavedir)/HW1_0.vcd
hw1_0_wave: $(vvp1_0) | $(wavedir)
	@echo [Homework 1 simulation and wave]
	$(VP) $^

hazard0_1a: hz0_1a_com hz0_1a_wave
v_hz0_1a = Hazard/Hazard0_1a.v Hazard/Hazard0_1t.v
vvp_hz0_1a = $(vvpdir)/Hazard0_1a.vvp
hz0_1a_com: $(v_hz0_1a) | $(vvpdir)
	@echo [Hazard test compile]
	$(IV) -o $(vvp_hz0_1a) $^
wave_hz0_1a = $(wavedir)/Hazard0_1a.vcd
hz0_1a_wave: $(vvp_hz0_1a) | $(wavedir)
	@echo [Hazard test simulation and wave]
	$(VP) $^

$(vvpdir):
	mkdir -p $(vvpdir)
$(wavedir):
	mkdir -p $(wavedir)

vvps = $(vvp0_1a) $(vvp0_2a) $(vvp1_0) $(vvp_hz0_1a)
waves = $(wave0_1a) $(wave0_2a) $(wave1_0) $(wave_hz0_1a)

.PHONY: clean
clean:
	rm -f $(vvps)
	rm -f $(waves)
	rm -rf $(vvpdir)
	rm -rf $(wavedir)
