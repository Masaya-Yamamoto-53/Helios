TCL_SCRIPT_IU = ./tcl/simulate_iu.tcl
LOG_PATH = ./log
UNIT_LOG_FILES =  $(LOG_PATH)/iualgnchk_test.log   \
                  $(LOG_PATH)/iualu_test.log       \
                  $(LOG_PATH)/iubprc_test.log      \
                  $(LOG_PATH)/iucall_test.log      \
                  $(LOG_PATH)/iucc_test.log        \
                  $(LOG_PATH)/iucmp_test.log       \
                  $(LOG_PATH)/iucond_test.log      \
                  $(LOG_PATH)/iuctrl_test.log      \
                  $(LOG_PATH)/iuet_test.log        \
                  $(LOG_PATH)/iuexma_test.log      \
                  $(LOG_PATH)/iufmt0dec_test.log   \
                  $(LOG_PATH)/iufmt1dec_test.log   \
                  $(LOG_PATH)/iufmt2dec_test.log   \
                  $(LOG_PATH)/iufmt3dec_test.log   \
                  $(LOG_PATH)/iufwpast_test.log    \
                  $(LOG_PATH)/iufwpastu_test.log   \
                  $(LOG_PATH)/iufwpre_test.log     \
                  $(LOG_PATH)/iufwpreu_test.log    \
                  $(LOG_PATH)/iuhdu_test.log       \
                  $(LOG_PATH)/iuidex_test.log      \
                  $(LOG_PATH)/iuifid_test.log      \
                  $(LOG_PATH)/iuintrdec_test.log   \
                  $(LOG_PATH)/iuintr_test.log      \
                  $(LOG_PATH)/iuld_test.log        \
                  $(LOG_PATH)/iumawb_test.log      \
                  $(LOG_PATH)/iumul32post_test.log \
                  $(LOG_PATH)/iumul32pre_test.log  \
                  $(LOG_PATH)/iumul32reg_test.log  \
                  $(LOG_PATH)/iupc_test.log        \
                  $(LOG_PATH)/iupil_test.log       \
                  $(LOG_PATH)/iurett_test.log      \
                  $(LOG_PATH)/iurfport_test.log    \
                  $(LOG_PATH)/iurfreg_test.log     \
                  $(LOG_PATH)/iurf_test.log        \
                  $(LOG_PATH)/iuschk_test.log      \
                  $(LOG_PATH)/iusft_test.log       \
                  $(LOG_PATH)/ius_test.log         \
                  $(LOG_PATH)/iust_test.log

INTEG_LOG_FILES = ./log/00_br.dump                      \
                  ./log/00_sethi.dump                   \
                  ./log/01_call.dump                    \
                  ./log/02_alu.dump                     \
                  ./log/02_sft.dump                     \
                  ./log/02_sext.dump                    \
                  ./log/02_mul.dump                     \
                  ./log/03_ldst.dump                    \
                  ./log/03_jmpl.dump                    \
                  ./log/03_psr.dump                     \
                  ./log/04_illegal_instruction.dump     \
                  ./log/04_mem_address_not_aligned.dump \
                  ./log/06_fwd.dump                     \
                  ./log/06_hdu.dump                     \
                  ./log/99_binary_search.dump           \
                  ./log/99_bubble_sort.dump             \
                  ./log/99_gcd.dump                     \
                  ./log/99_div.dump

IU_FILES = ../iualgnchk_pac.vhd  ../iualgnchk.vhd     \
           ../iualu_pac.vhd      ../iualu.vhd         \
           ../iubprc_pac.vhd     ../iubprc.vhd        \
           ../iucall_pac.vhd     ../iucall.vhd        \
           ../iucc_pac.vhd       ../iucc.vhd          \
           ../iucmp_pac.vhd      ../iucmp.vhd         \
           ../iucond_pac.vhd     ../iucond.vhd        \
           ../iuctrl_pac.vhd     ../iuctrl.vhd        \
           ../iudmem_pac.vhd     ../iudmem.vhd        \
           ../iuet_pac.vhd       ../iuet.vhd          \
           ../iuexln_pac.vhd     ../iuexln.vhd        \
           ../iuexma_pac.vhd     ../iuexma.vhd        \
           ../iuexstg_pac.vhd    ../iuexstg.vhd       \
           ../iufmt0dec_pac.vhd  ../iufmt0dec.vhd     \
           ../iufmt1dec_pac.vhd  ../iufmt1dec.vhd     \
           ../iufmt2dec_pac.vhd  ../iufmt2dec.vhd     \
           ../iufmt3dec_pac.vhd  ../iufmt3dec.vhd     \
           ../iufwpastu.vhd      ../iufwpast.vhd      \
           ../iufwpreu.vhd       ../iufwpre.vhd       \
           ../iufwu_pac.vhd                           \
           ../iuhdu_pac.vhd      ../iuhdu.vhd         \
           ../iuidex_pac.vhd     ../iuidex.vhd        \
           ../iuidln_pac.vhd     ../iuidln.vhd        \
           ../iuidstg_pac.vhd    ../iuidstg.vhd       \
           ../iuifid_pac.vhd     ../iuifid.vhd        \
           ../iuifln_pac.vhd     ../iuifln.vhd        \
           ../iuifstg_pac.vhd    ../iuifstg.vhd       \
           ../iuintrdec_pac.vhd  ../iuintrdec.vhd     \
           ../iuintr_pac.vhd     ../iuintr.vhd        \
           ../iumaln_pac.vhd     ../iumaln.vhd        \
           ../iumastg_pac.vhd    ../iumastg.vhd       \
           ../iumawb_pac.vhd     ../iumawb.vhd        \
           ../iumul32_pac.vhd    ../iumul32post.vhd ../iumul32pre.vhd ../iumul32reg.vhd    \
           ../iu_pac.vhd                              \
           ../iupc_pac.vhd       ../iupc.vhd          \
           ../iupil_pac.vhd      ../iupil.vhd         \
           ../iurett_pac.vhd     ../iurett.vhd        \
           ../iurf_pac.vhd                            \
           ../iurfport_pac.vhd   ../iurfport.vhd      \
           ../iurfreg_pac.vhd    ../iurfreg.vhd       \
           ../iurf.vhd                                \
           ../iuschk_pac.vhd     ../iuschk.vhd        \
           ../iusft_pac.vhd      ../iusft.vhd         \
           ../iuldst_pac.vhd                          \
           ../iuld.vhd                                \
           ../iustdo_pac.vhd     ../iustdo.vhd        \
           ../iustdqm_pac.vhd    ../iustdqm.vhd       \
           ../iust.vhd                                \
           ../ius_pac.vhd        ../ius.vhd           \
           ../iu.vhd

all : $(UNIT_LOG_FILES) $(INTEG_LOG_FILES)
	python3 ./sum.py

./log/%_test.log : ./vhd/%_test.vhd ./dat/%_test.dat
	vivado -quiet -mode tcl -log /dev/null -jou /dev/null -source $(TCL_SCRIPT_IU) -tclargs $(IU_FILES) $<

./log/%.dump : ./src/%.s ./vhd/iu_test.vhd
	../../has/has $< > ./pattern/iu_test.dat
	vivado -quiet -mode tcl -log /dev/null -jou /dev/null -source $(TCL_SCRIPT_IU) -tclargs $(IU_FILES) ./vhd/iu_test.vhd
	mv ./log/iu_test.dump $@

clean:
	rm -rf *.cache
	rm -rf *.hw
	rm -rf *.ip_user_files
	rm -rf *.sim
	rm -rf *.xpr
	rm -rf *.jou *.log
	rm -rf $(UNIT_LOG_FILES)
	rm -rf $(INTEG_LOG_FILES)
	rm -rf projects/*
