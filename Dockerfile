## Start with the rstudio image providing 'base R' as well as RStudio based on Debian testing
FROM rocker/rstudio

## This handle reaches Carl and Dirk
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

## Add CRAN binaries and update
RUN echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
&& gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379 \ 
&& gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add -

## We need the deb-src repositories to use apt-get build-dep
RUN echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
&& echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list 


## rmarkdown needs pandoc, and works best with some additional (large!) latex libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-jdk \
    default-jre \
    ghostscript \
    imagemagick \
    libcairo2-dev \
    libgsl0-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    libxslt1-dev \
    lmodern \
    r-cran-rgl \
    r-cran-rsqlite.extfuns \
    texlive-fonts-recommended \
    texlive-humanities \
    texlive-latex-extra \
&& R CMD javareconf 

## Install the latest BiocInstaller
RUN Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("BiocInstaller")'


## Finally ready to install the R packages.  NOTE: failure to install a package doesn't throw an image build error. 
## Install devtools, ggplot2, dplyr, tidyr + full suggests lists
RUN install2.r --error --deps TRUE \
    devtools \
    dplyr \
    ggplot2 \
    httr \ 
    knitr \
    Rcpp \
    reshape2 \
    rJava \
    rmarkdown \
    roxygen2 \
    testthat \
    tidyr \
    shiny \
&& rm -rf /tmp/downloaded_packages/

## Add a few github repos where the CRAN version isn't sufficiently recent (e.g. has outstanding bugs) 
RUN installGithub.r \
    hadley/lineprof \
    hadley/reshape \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## Some convenience tools and configurations, particularly for command-line mode
RUN echo '"\e[5~": history-search-backward' >> /etc/inputrc \
&& echo '"\e[6~": history-search-backward' >> /etc/inputrc \
&& apt-get update && apt-get install -y vim

