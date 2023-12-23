# Definition of Variable Names
set project_name "./project_1"
set part_number "xc7a35tcpg236-1"
set sim_time "-1"

# Test bance name
set testbench_name "iufmt3dec_test"

# Create Vivado Project
create_project -force  $project_name -part $part_number

# Add Files
add_files ../iufmt3dec.vhd
add_files ../iuctrl_pac.vhd
add_files ../iu_pac.vhd
add_files ../iumawb_pac.vhd
add_files ../iurf_pac.vhd
add_files ../iualu_pac.vhd
add_files ../iucond_pac.vhd
add_files ../iuldst_pac.vhd
add_files ../iufmt3dec_pac.vhd
add_files ./vhd/iufmt3dec_test.vhd

# Settings
update_compile_order -fileset sources_1
set_property top $testbench_name [get_filesets sim_1]
set_property simulator_language VHDL [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {$sim_time} -objects [get_filesets sim_1]

# Start the simulation
launch_simulation

# Close
close_project

# TCL End
exit
