CASTS_DIR := ./site/casts
CASTS_SRC := $(wildcard $(CASTS_DIR)/*.cast)
CASTS_DST := $(patsubst %.cast, %.svg, $(CASTS_SRC))
SVGTERM_BIN := yarn svg-term
SVGTERM_ARGS := --width 60 --height 28 --padding 8

_site: $(CASTS_DST)
	yarn build

$(CASTS_DIR)/%.svg:
	cat $(CASTS_DIR)/$*.cast | $(SVGTERM_BIN) --out $@ $(SVGTERM_ARGS)

clean:
	rm -f site/casts/*.svg
	rm -rf _site

NEWS_SRC := $(shell git grep -l "layout: news" gh-pages/ )
NEWS := $(patsubst gh-pages/_posts/%, %, $(NEWS_SRC))
NEWS_DST := $(addsuffix .md, $(addprefix site/news/, $(NEWS)))
site/news/%.md:
	git mv gh-pages/_posts/$* $@

config: $(NEWS_DST)
	echo $(NEWS)
	echo $(NEWS_DST)


.PHONY: clean

