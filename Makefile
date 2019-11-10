SHELL := /bin/bash

ROOT_DIR := $(shell pwd)
BUILD_DIR := $(ROOT_DIR)/build
DATA_DIR := $(ROOT_DIR)/Data

BUILD_TYPE := Release
WITH_PAPI := 0
STEPS := '0'

STEP := 0
BIG_DATA := 0
PAPI_EVENTS := ''

MODULES := intel PAPI HDF5 CMake Python/3.6.1

PACK := xharmi00
STEP_DRIS := Step0


.PHONY: build
build:
	ml $(MODULES) && \
		mkdir -p $(BUILD_DIR) && \
		cd $(BUILD_DIR) && \
		cmake $(ROOT_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
			-DWITH_PAPI=$(WITH_PAPI) -DSTEPS=$(STEPS) && \
		make -j


.PHONY: run
run:
ifeq ($(BIG_DATA), 0)
	ml $(MODULES) && \
		PAPI_EVENTS=$(PAPI_EVENTS) && \
		$(BUILD_DIR)/Step$(STEP)/ANN $(DATA_DIR)/network.h5 \
			$(DATA_DIR)/testData.h5 $(BUILD_DIR)/Step$(STEP)/output.h5
else
	ml $(MODULES) && \
		PAPI_EVENTS=$(PAPI_EVENTS) && \
		$(BUILD_DIR)/Step$(STEP)/ANN $(DATA_DIR)/network.h5 \
			$(DATA_DIR)/bigDataset.h5 $(BUILD_DIR)/Step$(STEP)/output.h5
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
