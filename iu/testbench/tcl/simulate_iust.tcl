# Definition of Variable Names
set project_name "./project_1"
set part_number "xc7a35tcpg236-1"
set sim_time "-1"

# Test bance name
set testbench_name "iust_test"

# Create Vivado Project
create_project -force  $project_name -part $part_number

# Add Files
add_files ../iust.vhd
add_files ../iuldst_pac.vhd
add_files ../iustdqm_pac.vhd
add_files ../iustdo_pac.vhd
add_files ./vhd/iust_test.vhd

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
