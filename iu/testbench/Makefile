#
	#vivado -mode tcl -source ./tcl/simulate_iualgnchk.tcl
	#vivado -mode tcl -source ./tcl/simulate_iualu.tcl
	#vivado -mode tcl -source ./tcl/simulate_iubprc.tcl
	#vivado -mode tcl -source ./tcl/simulate_iucall.tcl
	#vivado -mode tcl -source ./tcl/simulate_iucc.tcl
	#vivado -mode tcl -source ./tcl/simulate_iucmp.tcl
	#vivado -mode tcl -source ./tcl/simulate_iucond.tcl
	#vivado -mode tcl -source ./tcl/simulate_iuctrl.tcl
#iudmem.vhd       :  
	#vivado -mode tcl -source ./tcl/simulate_iuet.tcl
#iuexln.vhd       : -
#iuexma.vhd       : O    iuexma_test.dat
#iuexstg.vhd      : -
	#vivado -mode tcl -source ./tcl/simulate_iufmt0dec.tcl
	#vivado -mode tcl -source ./tcl/simulate_iufmt1dec.tcl
	#vivado -mode tcl -source ./tcl/simulate_iufmt2dec.tcl
	#vivado -mode tcl -source ./tcl/simulate_iufmt3dec.tcl
	#vivado -mode tcl -source ./tcl/simulate_iufwpastu.tcl
	#vivado -mode tcl -source ./tcl/simulate_iufwpast.tcl
	#vivado -mode tcl -source ./tcl/simulate_iufwpreu.tcl
	#vivado -mode tcl -source ./tcl/simulate_iufwpre.tcl
	#vivado -mode tcl -source ./tcl/simulate_iuhdu.tcl
#iuidex.vhd       : O    iuidex_test.dat
#iuidln.vhd       : -
#iuidstg.vhd      : -
#iuifid.vhd       : O    iuifid_test.dat
#iuifln.vhd       : -
#iuifstg.vhd      : -
#iuimem.vhd       :  
	#vivado -mode tcl -source ./tcl/simulate_iuintrdec.tcl
#iuintr.vhd       : O    iuintr_test.dat
	#vivado -mode tcl -source ./tcl/simulate_iuld.tcl
#iumaln.vhd       : -
#iumastg.vhd      : -
#iumawb.vhd       : O    iumawb_test.dat
	#vivado -mode tcl -source ./tcl/simulate_iumul32post.tcl
	#vivado -mode tcl -source ./tcl/simulate_iumul32pre.tcl
	#vivado -mode tcl -source ./tcl/simulate_iumul32reg.tcl
	#vivado -mode tcl -source ./tcl/simulate_iupc.tcl
	#vivado -mode tcl -source ./tcl/simulate_iupil.tcl
	#vivado -mode tcl -source ./tcl/simulate_iurett.tcl
	#vivado -mode tcl -source ./tcl/simulate_iurfport.tcl
	#vivado -mode tcl -source ./tcl/simulate_iurfreg.tcl
	#vivado -mode tcl -source ./tcl/simulate_iurf.tcl
	#vivado -mode tcl -source ./tcl/simulate_iuschk.tcl
	#vivado -mode tcl -source ./tcl/simulate_iusft.tcl
	#vivado -mode tcl -source ./tcl/simulate_iustdo.tcl
	#vivado -mode tcl -source ./tcl/simulate_iustdqm.tcl
	#vivado -mode tcl -source ./tcl/simulate_iust.tcl
	#vivado -mode tcl -source ./tcl/simulate_ius.tcl
simulate:
	vivado -mode tcl -source ./tcl/simulate_iuifid.tcl
	python3 ./sum.py

clean:
	rm -rf *.cache
	rm -rf *.hw
	rm -rf *.ip_user_files
	rm -rf *.sim
	rm -rf *.xpr
	rm -rf *.jou *.log
