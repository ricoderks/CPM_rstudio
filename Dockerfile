FROM rocker/rstudio
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

## Add binaries for more CRAN packages, deb-src repositories in case we need `apt-get build-dep`
RUN echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
	&& gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379 \ 
	&& gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add - \
	&& echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
	&& echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list 

## Install some external dependencies. 360 MB
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
    build-essential \
    default-jdk \
    default-jre \
    libcairo2-dev \
    libgsl0-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    libxslt1-dev \
    libxt-dev \
    r-cran-rgl \
    r-cran-rsqlite.extfuns \
		vim \
	&& R CMD javareconf \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/

## Install the R packages. 210 MB
RUN install2.r --error \
    devtools \
    dplyr \
    ggplot2 \
    httr \ 
    knitr \
		packrat \
    reshape2 \
    rmarkdown \
    testthat \
    tidyr \
    shiny \
## Manually install (useful packages from) the SUGGESTS list of the above packages.
## (because --deps TRUE can fail when packages are added/removed from CRAN)
&& Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("BiocInstaller")' \
&& install2.r --error \
		base64enc \
		Cairo \
		codetools \
		data.table \
		hexbin \
		Hmisc \
		jpeg \
		Lahman \
		lattice \
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
 		RCurl \
	  rJava \
    roxygen2 \
		RMySQL \
		RPostgreSQL \
		RSQLite \
		testit \
		XML \
&& installGithub.r \
    hadley/lineprof \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## LaTeX: 
## Install a more complete LaTeX environment for dev work & rmarkdown pdf output
## Installs inconsolata fonts used in R vignettes/manuals manually since texlive-fonts-extra is HUGE
RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
    ghostscript \
    imagemagick \
    lmodern \
    texlive-fonts-recommended \
    texlive-humanities \
    texlive-latex-extra \
		texinfo \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/ \ 
	&& mkdir /data && cd /data \ 
	&& wget http://mirrors.ctan.org/install/fonts/inconsolata.tds.zip \
	&& unzip inconsolata.tds.zip \
	&& rm inconsolata.tds.zip \
	&& mkdir -p /usr/local/texlive/texmf-local/web2c \ 
	&& cp -Rfp * /usr/local/texlive/texmf-local \
	&& echo Map zi4.map >> /usr/local/texlive/texmf-local/web2c/updmap.cfg \
	&& mktexlsr \
	&& updmap-sys \
	&& rm -rf /data 
