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

RELEASES_SRC := $(shell git grep -l "layout: changelog" gh-pages/_posts )
RELEASES_DST := $(addprefix site/releases/, $(notdir $(RELEASES_SRC)))
site/releases/%:
	git mv gh-pages/_posts/$* $@

releases: $(RELEASES_DST)
	echo $(RELEASES_DST)


.PHONY: clean releases

