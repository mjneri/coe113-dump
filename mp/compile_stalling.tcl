read_verilog alu.v
read_verilog control.v
read_verilog exe_mem.v
read_verilog id_exe_stalling.v
read_verilog if_id_stalling.v
read_verilog mem_wb.v
read_verilog pipelined_mips_stalling.v
read_verilog rf.v
read_verilog sel_pc_blk.v
read_verilog hazard_unit.v
current_design pipelined_mips_stalling
link
check_design > logs/check_design_stalling.log
source timing.con
compile
report_constraint -all_violators > logs/constraint_report_stalling.log
report_area > logs/area_report_stalling.log
report_timing > logs/timing_report_stalling.log
write_sdf -version 1.0 mapped/pipelined_mips_stalling_mapped.v
write -f verilog -hier -out mapped/pipelined_mips_stalling_mapped.v
quit
