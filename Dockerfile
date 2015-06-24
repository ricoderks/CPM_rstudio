FROM rocker/rstudio
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

## Add binaries for more CRAN packages, deb-src repositories in case we need `apt-get build-dep`
RUN echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379 \
  && gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add - \
  && echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
  && echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list

## LaTeX:
## This installs inconsolata fonts used in R vignettes/manuals manually since texlive-fonts-extra is HUGE

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    aspell \
    aspell-en \
    ghostscript \
    imagemagick \
    lmodern \
    texlive-fonts-recommended \
    texlive-humanities \
    texlive-latex-extra \
    texinfo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && cd /usr/share/texlive/texmf-dist \
  && wget http://mirrors.ctan.org/install/fonts/inconsolata.tds.zip \
  && unzip inconsolata.tds.zip \
  && rm inconsolata.tds.zip \
  && echo "Map zi4.map" >> /usr/share/texlive/texmf-dist/web2c/updmap.cfg \
  && mktexlsr \
  && updmap-sys

## Install some external dependencies. 360 MB
RUN apt-get update \
  && apt-get install -y --no-install-recommends -t unstable \
    build-essential \
    default-jdk \
    default-jre \
    libcairo2-dev \
    libssl-dev \
    libgsl0-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    libv8-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxml2-dev \
    libxslt1-dev \
    libxt-dev \
    r-cran-rgl \
    r-cran-rsqlite.extfuns \
    vim \
  && R CMD javareconf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install the R packages. 210 MB
RUN install2.r --error \
    broom \
    DiagrammeR \
    devtools \
    dplyr \
    ggplot2 \
    haven \
    httr \
    knitr \
    packrat \
    pryr \
    reshape2 \
    rmarkdown \
    rvest \
    readr \
    readxl \
    testthat \
    tidyr \
    shiny \
    xml2 \
## Manually install (useful packages from) the SUGGESTS list of the above packages.
## (because --deps TRUE can fail when packages are added/removed from CRAN)
&& Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("BiocInstaller")' \
&& install2.r --error \
    base64enc \
    Cairo \
    codetools \
    covr \
    data.table \
    downloader \
    gridExtra \
    gtable \
    hexbin \
    Hmisc \
    htmlwidgets \
    jpeg \
    Lahman \
    lattice \
    lintr \
    MASS \
    PKI \
    png \
    microbenchmark \
    mgcv \
    mapproj \
    maps \
    maptools \
    mgcv \
    multcomp \
    nlme \
    nycflights13 \
    quantreg \
    Rcpp \
    rJava \
    roxygen2 \
    RMySQL \
    RPostgreSQL \
    RSQLite \
    testit \
    V8 \
    XML \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## httr authentication uses this port
EXPOSE 1410
ENV HTTR_LOCALHOST 0.0.0.0
