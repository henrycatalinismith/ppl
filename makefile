CASTS_DIR := ./site/casts
CASTS_SRC := $(wildcard $(CASTS_DIR)/*.cast)
CASTS_DST := $(patsubst %.cast, %.svg, $(CASTS_SRC))
SVGTERM_BIN := yarn svg-term
SVGTERM_ARGS := --width 60 --height 28 --padding 8

_site: $(CASTS_DST)
	yarn eleventy

$(CASTS_DIR)/%.svg:
	cat $(CASTS_DIR)/$*.cast | $(SVGTERM_BIN) --out $@ $(SVGTERM_ARGS)

clean:
	rm -f site/casts/*.svg
	rm -rf _site

.PHONY: clean

