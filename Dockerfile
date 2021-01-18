FROM rocker/tidyverse:latest
LABEL maintainer "Rico Derks" r.j.e.derks@lumc.nl

## install some packages I need (e.g. from bioconductor)
## not yet the same approach as above (i.e. install SUGGETS list manually)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    subversion \
    netcdf-bin \
    libnetcdf-dev \
  && . /etc/environment
  
RUN  install2.r --error --skipinstalled \ 
    rsm \
    pls \
    plotly \
    VennDiagram \
    sessioninfo \
    tidyxl \
    openxlsx \
    patchwork \
    gt \
    unpivotr \
    ggrepel \
    pheatmap \
    here
  #&& r -e 'source("https://raw.githubusercontent.com/MangoTheCat/remotes/master/install-github.R")$value("mangothecat/remotes")' \
  
RUN R -e 'BiocManager::install(c("xcms", "CAMERA", "multtest", "preprocessCore", "pcaMethods"))' \
  && R -e 'devtools::install_github("ricoderks/Rcpm")' \
  && R -e 'devtools::install_github("ricoderks/ggCPM")' 
  
RUN  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
