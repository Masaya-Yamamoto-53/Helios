AS_PATH=../has/
TB_PATH=../tb/iu/

all: has
	make -C $(TB_PATH)/it

rom: has
	./make_rom.sh

has:
	make -C $(AS_PATH)

clean:
	make -C $(AS_PATH) clean
	make -C $(TB_PATH)/it clean
