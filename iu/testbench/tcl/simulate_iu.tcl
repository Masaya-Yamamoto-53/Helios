# Test bance name
set filepath [lindex $argv end]
set filename [file tail $filepath]
set testbench_name [file rootname $filename]

# Definition of Variable Names
set project_prefix "./project_"
set dir_name "./projects/"
set project_name $dir_name$project_prefix$testbench_name
set part_number "xc7a35tcpg236-1"
set sim_time "-1"

if {[file exists $project_name]} {
    # Open Vivado Project
    open_projext $project_name
} else {
    # Create Vivado Project
    create_project -force  $project_name -part $part_number

    # Add Files
    set args [lrange $argv 0 end]
    foreach arg $args {
        add_files $arg
    }

    # Settings
    update_compile_order -fileset sources_1
    set_property top $testbench_name [get_filesets sim_1]
    set_property simulator_language VHDL [get_filesets sim_1]
    set_property -name {xsim.simulate.runtime} -value {$sim_time} -objects [get_filesets sim_1]
}

if {[catch {
    # Start the simulation
    launch_simulation

    # Close
    close_project

    # TCL End
    exit
} errMsg]} {
    # TCL End
    exit
}

