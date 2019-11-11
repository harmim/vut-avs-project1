SHELL := /bin/bash

ROOT := $(shell pwd)
BUILD := $(ROOT)/build
DATA := $(ROOT)/Data
SCRIPTS := $(ROOT)/Scripts

MODULES := intel PAPI HDF5 CMake Python/3.6.1

BIG_DATA := 0

BUILD_TYPE := Release
PAPI := 0
STEPS := 0

STEP := 0
FLOPS := 0
CACHES := 0
ifneq ($(FLOPS), 0)
	EVENTS := PAPI_FP_OPS|PAPI_SP_OPS
else ifneq ($(CACHES), 0)
	EVENTS := PAPI_L1_DCM|PAPI_LD_INS|PAPI_SR_INS|PAPI_L2_DCM|PAPI_L2_DCA|PAPI_L3_TCM|PAPI_L3_TCA
else
	EVENTS :=
endif

PACK := xharmi00
STEP_DRIS := Step0 Step1 Step2 Step3


.PHONY: build
build:
	ml $(MODULES) && \
		mkdir -p $(BUILD) && \
		cd $(BUILD) && \
		cmake $(ROOT) -DCMAKE_BUILD_TYPE='$(BUILD_TYPE)' -DWITH_PAPI=$(PAPI) \
			-DSTEPS='$(STEPS)' && \
		make -j


.PHONY: run
run:
ifeq ($(BIG_DATA), 0)
	ml $(MODULES) && \
		PAPI_EVENTS='$(EVENTS)' \
		$(BUILD)/Step$(STEP)/ANN $(DATA)/network.h5 $(DATA)/testData.h5 \
			$(BUILD)/Step$(STEP)/output.h5
else
	ml $(MODULES) && \
		PAPI_EVENTS='$(EVENTS)' \
		$(BUILD)/Step$(STEP)/ANN $(DATA)/network.h5 $(DATA)/bigDataset.h5 \
			$(BUILD)/Step$(STEP)/output.h5
endif


.PHONY: compare
compare:
ifeq ($(BIG_DATA), 0)
	ml $(MODULES) && \
		python3 $(SCRIPTS)/compareOutputs.py $(BUILD)/Step$(STEP)/output.h5 \
			$(DATA)/testRefOutput.h5
else
	ml $(MODULES) && \
		python3 $(SCRIPTS)/compareOutputs.py $(BUILD)/Step$(STEP)/output.h5 \
			$(DATA)/bigRefOutput.h5
endif


.PHONY: papiav
papiav:
	ml $(MODULES) && papi_avail


.PHONY: qsub
qsub:
	qsub -A DD-19-32 -q qexp -l select=1:ncpus=16,walltime=1:00:00 -I


.PHONY: pack
pack: $(PACK).zip

$(PACK).zip:
	zip -r $@ ANN-$(PACK).txt $(STEP_DRIS)
