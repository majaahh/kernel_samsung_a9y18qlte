ifeq ($(filter y,$(CONFIG_MACH_A9Y18QLTE_SWA)),y)
dtb-y = sdm660-sec-a9y18qlte-swa-r00.dtb 
endif

ifeq ($(filter y,$(CONFIG_MACH_A9Y18QLTE_CIS)),y)
dtb-y = sdm660-sec-a9y18qlte-cis-r00.dtb \
	sdm660-sec-a9y18qlte-cis-r01.dtb \
	sdm660-sec-a9y18qlte-cis-r02.dtb \
	sdm660-sec-a9y18qlte-cis-r03.dtb \
	sdm660-sec-a9y18qlte-cis-r04.dtb \
	sdm660-sec-a9y18qlte-cis-r05.dtb \
	sdm660-sec-a9y18qlte-cis-r06.dtb
endif

ifeq ($(filter y,$(CONFIG_MACH_A9Y18QLTE_CHN)),y)
dtb-y = sdm660-sec-a9y18qlte-chn-r01.dtb \
	sdm660-sec-a9y18qlte-chn-r02.dtb \
	sdm660-sec-a9y18qlte-chn-r03.dtb \
	sdm660-sec-a9y18qlte-chn-r04.dtb \
	sdm660-sec-a9y18qlte-chn-r05.dtb \
	sdm660-sec-a9y18qlte-chn-r06.dtb
endif

ifeq ($(filter y,$(CONFIG_MACH_A9Y18QLTE_CHNLDU)),y)
dtb-y = sdm660-sec-a9y18qlte-chnldu-r01.dtb \
	sdm660-sec-a9y18qlte-chnldu-r02.dtb \
	sdm660-sec-a9y18qlte-chnldu-r03.dtb \
	sdm660-sec-a9y18qlte-chnldu-r04.dtb \
	sdm660-sec-a9y18qlte-chnldu-r05.dtb \
	sdm660-sec-a9y18qlte-chnldu-r06.dtb
endif

ifeq ($(filter y,$(CONFIG_MACH_A9Y18QLTE_EUR)),y)
dtb-y = sdm660-sec-a9y18qlte-eur-r01.dtb \
	sdm660-sec-a9y18qlte-eur-r02.dtb \
	sdm660-sec-a9y18qlte-eur-r03.dtb \
	sdm660-sec-a9y18qlte-eur-r04.dtb \
	sdm660-sec-a9y18qlte-eur-r05.dtb \
	sdm660-sec-a9y18qlte-eur-r06.dtb
endif

ifeq ($(filter y,$(CONFIG_MACH_A9Y18QLTE_EURLDU)),y)
dtb-y = sdm660-sec-a9y18qlte-eurldu-r01.dtb \
	sdm660-sec-a9y18qlte-eurldu-r02.dtb \
	sdm660-sec-a9y18qlte-eurldu-r03.dtb \
	sdm660-sec-a9y18qlte-eurldu-r04.dtb \
	sdm660-sec-a9y18qlte-eurldu-r05.dtb \
	sdm660-sec-a9y18qlte-eurldu-r06.dtb
endif

ifeq ($(filter y,$(CONFIG_MACH_A9Y18QLTE_KOR)),y)
dtb-y = sdm660-sec-a9y18qlte-kor-r06.dtb
endif

ifeq ($(CONFIG_ARM64),y)
always          := $(dtb-y)
subdir-y        := $(dts-dirs)
else
targets += dtbs
targets += $(addprefix ../, $(dtb-y))

$(obj)/../%.dtb: $(src)/%.dts FORCE
        $(call if_changed_dep,dtc)

dtbs: $(addprefix $(obj)/../,$(dtb-y))
endif
clean-files := *.dtb *.reverse.dts
