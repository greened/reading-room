# Build every reading guide (HTML -> PDF). The PDFs are artifacts, not committed.
#
#   make            # render all guides to PDF
#   make fetch      # run every topic's fetch.sh (downloads papers/books)
#   make clean      # remove rendered PDFs
#   make list       # show discovered guides
#
# A single guide:  make machine-learning/transformers/reading-guide.pdf

RENDER := bin/render.sh
GUIDES := $(shell find . -name reading-guide.html)
PDFS   := $(GUIDES:.html=.pdf)
FETCHERS := $(shell find . -name fetch.sh)

.PHONY: all guides fetch clean list
all: guides
guides: $(PDFS)

%.pdf: %.html $(RENDER) lib/guide.css
	$(RENDER) $< $@

fetch:
	@for f in $(FETCHERS); do echo ">> $$f"; ( cd $$(dirname $$f) && ./fetch.sh ); done

clean:
	rm -f $(PDFS)

list:
	@echo "guides:"; for g in $(GUIDES); do echo "  $$g"; done
