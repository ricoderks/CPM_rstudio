FROM rocker/rstudio
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

## LaTeX:
## This installs inconsolata fonts used in R vignettes/manuals manually since texlive-fonts-extra is HUGE

RUN apt-get update \
  && apt-get install -t unstable -y --no-install-recommends \
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

## Install some external dependencies. 
RUN apt-get update \
  && apt-get install -y --no-install-recommends -t unstable \
    default-jdk \
    default-jre \
    gdal-bin \
    icedtea-netx \
    libatlas-base-dev \
    libcairo2-dev \
    libhunspell-dev \
    libgsl-dev \
    libgdal-dev \
    libgeos-dev \
    libgeos-c1v5 \
    librdf0-dev \
    libssl-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    librsvg2-dev \
    libv8-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxml2-dev \
    libxslt1-dev \
    libxt-dev \
    mdbtools \
    netcdf-bin \
    qpdf \
    r-cran-rgl \
    ssh \
    vim \
  && R CMD javareconf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install the Hadleyverse packages (and some close friends). 
RUN install2.r --error \
    broom \
    DiagrammeR \
    devtools \
    dplyr \
    ggplot2 \
    ggthemes \
    haven \
    httr \
    knitr \
    lubridate \
    packrat \
    pryr \
    purrr \
    reshape2 \
    readr \
    readxl \
    revealjs \
    rmarkdown \
    rmdformats \
    rstudioapi \
    rticles \
    rvest \
    rversions \
    testthat \
    tidyr \
    servr \
    shiny \
    stringr \
    svglite \
    tibble \
    tufte \
    xml2 


## Manually install (useful packages from) the SUGGESTS list of the above packages.
## (because --deps TRUE can fail when packages are added/removed from CRAN)
RUN install2.r --error \
    -r "https://cran.rstudio.com" \
    -r "http://www.bioconductor.org/packages/release/bioc" \
    base64enc \
    BiocInstaller \
    bitops \
    crayon \
    codetools \
    covr \
    data.table \
    downloader \
    evaluate \
    git2r \
    gridExtra \
    gmailr \
    gtable \
    hexbin \
    Hmisc \
    htmlwidgets \
    hunspell \
    jpeg \
    Lahman \
    lattice \
    lintr \
    MASS \
    openxlsx \
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
    withr \
    XML \
  && r -e 'source("https://raw.githubusercontent.com/MangoTheCat/remotes/master/install-github.R")$value("mangothecat/remotes")' \
  && r -e 'remotes::install_github("wesm/feather/R")' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

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
	&& r -e 'source("https://raw.githubusercontent.com/MangoTheCat/remotes/master/install-github.R")$value("mangothecat/remotes")' \
	&& r -e 'remotes::install_github("vanmooylipidomics/LOBSTAHS")' \
	&& r -e 'remotes::install_github("rietho/IPO")' \
	&& r -e 'remotes::install_git("https://git.lumc.nl/rjederks/Rcpm.git")'
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## httr authentication uses this port
EXPOSE 1410
ENV HTTR_LOCALHOST 0.0.0.0
