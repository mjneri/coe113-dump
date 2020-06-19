read_verilog alu.v
read_verilog control.v
read_verilog exe_mem.v
read_verilog id_exe.v
read_verilog if_id.v
read_verilog mem_wb.v
read_verilog pipelined_mips_raw.v
read_verilog rf.v
read_verilog sel_pc_blk.v
current_design pipelined_mips_raw
link
check_design > logs/check_design_raw.log
source timing.con
compile
report_constraint -all_violators > logs/constraint_report_raw.log
report_area > logs/area_report_raw.log
report_timing > logs/timing_report_raw.log
write_sdf -version 1.0 mapped/pipelined_mips_raw_mapped.v
write -f verilog -hier -out mapped/pipelined_mips_raw_mapped.v
quit
