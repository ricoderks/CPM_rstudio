FROM rocker/verse:latest
LABEL maintainer "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

## install some packages I need (e.g. from bioconductor)
## not yet the same approach as above (i.e. install SUGGETS list manually)
RUN . /etc/environment \
  && install2.r --error \
    --repos 'https://lib.ugent.be/CRAN/' \
    --repos 'http://www.bioconductor.org/packages/release/bioc' \
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
  && r -e 'remotes::install_github("ricoderks/Rcpm")' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

