FROM rocker/tidyverse:latest
LABEL maintainer "Rico Derks" r.j.e.derks@lumc.nl

## install some packages I need (e.g. from bioconductor)
## not yet the same approach as above (i.e. install SUGGETS list manually)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    subversion \
    netcdf-bin \
    libnetcdf-dev \
  && . /etc/environment \
  && install2.r --error \
    --repos $MRAN \
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
    sessioninfo \
    tidyxl \
  && r -e 'source("https://raw.githubusercontent.com/MangoTheCat/remotes/master/install-github.R")$value("mangothecat/remotes")' \
  && r -e 'devtools::install_github("ricoderks/Rcpm")' \
  && r -e 'devtools::install_github("ricoderks/ggCPM")' \
  && r -e 'devtools::install_github("nacnudus/unpivotr")' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN usermod -u 36480 rstudio
RUN usermod -G `Domain Users` rstudio
