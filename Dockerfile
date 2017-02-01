FROM rocker/hadleyverse
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

## install some packages I need (e.g. from bioconductor)
## not yet the same approach as above (i.e. install SUGGETS list manually)
RUN install2.r --error \
	-r "https://lib.ugent.be/CRAN/" \
       -r "http://www.bioconductor.org/packages/release/bioc" \
	xcms \
	CAMERA \
	rsm \
	pcaMethods \
	pls \
	preprocessCore \
	plotly \
	multtest \
	VennDiagram \
	&& r -e 'source("https://raw.githubusercontent.com/MangoTheCat/remotes/master/install-github.R")$value("mangothecat/remotes")' \
	&& r -e 'remotes::install_github("vanmooylipidomics/LOBSTAHS")' \
	&& r -e 'remotes::install_github("rietho/IPO")' \
	&& r -e 'remotes::install_git("https://git.lumc.nl/rjederks/Rcpm.git")' \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

