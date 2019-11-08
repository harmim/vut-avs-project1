PACK := xharmi00
STEP_DRIS := Step0


.PHONY: pack
pack: $(PACK).zip

$(PACK).zip:
	zip -r $@ ANN-$(PACK).txt $(STEP_DRIS)
