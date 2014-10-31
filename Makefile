TEX=tex
PDFLATEX=pdflatex
DTX=bigfoot.dtx suffix.dtx perpage.dtx
DIST=$(DTX) Makefile bigfoot.ins README

all: $(DIST) $(DTX:.dtx=.sty) $(DTX:.dtx=.drv) $(DTX:.dtx=.pdf)

bigfoot-mk.ins: bigfoot.dtx Makefile
	$(TEX) '\nonstopmode \def\jobname{.ins}\input docstrip ' \
	'\askforoverwritefalse \nopreamble' \
	'\generate{\file{bigfoot-mk.ins}{\from{bigfoot.dtx}{installer,make}}}' \
	'\endbatchfile'

# Not generated by bigfoot-mk.ins in order to allow for hand-editing,
# like putting debug options in
bigfoot.ins: bigfoot.dtx Makefile
	$(TEX) '\nonstopmode \def\jobname{.ins}\input docstrip ' \
	'\askforoverwritefalse \nopreamble' \
	'\generate{\file{bigfoot.ins}{\from{bigfoot.dtx}{installer}}}' \
	'\endbatchfile'

bigfoot.drv bigfoot.sty perpage.drv perpage.sty suffix.drv suffix.sty: bigfoot-mk.ins
	$(TEX) bigfoot-mk.ins

bigfoot.drv bigfoot.sty: bigfoot.dtx
perpage.drv perpage.sty: perpage.dtx
suffix.drv suffix.sty: suffix.dtx

bigfoot.pdf: bigfoot.dtx bigfoot.drv bigfoot.sty perpage.sty suffix.sty
	$(PDFLATEX) '\nonstopmode\input{bigfoot.drv}'
	$(PDFLATEX) '\nonstopmode\input{bigfoot.drv}'
	$(PDFLATEX) '\nonstopmode\input{bigfoot.drv}'

perpage.pdf: perpage.dtx perpage.drv
	$(PDFLATEX) '\nonstopmode\input{perpage.drv}'
	$(PDFLATEX) '\nonstopmode\input{perpage.drv}'
	$(PDFLATEX) '\nonstopmode\input{perpage.drv}'

suffix.pdf: suffix.dtx suffix.drv
	$(PDFLATEX) '\nonstopmode\input{suffix.drv}'
	$(PDFLATEX) '\nonstopmode\input{suffix.drv}'
	$(PDFLATEX) '\nonstopmode\input{suffix.drv}'

bigfoot.tar.gz: $(DIST)
	tar czf $@ $(DIST)
