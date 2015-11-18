# ------------------------------
#
# Build for Census At School (CAS)
#
# ------------------------------

FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# install R packages specific to iNZight CAS
RUN apt-get install -y --no-install-recommends libmysqlclient-dev \
  && R -e "install.packages(c('RMySQL'), repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
  && rm -rf /srv/shiny-server/* \
  && git clone https://github.com/iNZightVIT/CAS.git \
  && rm -rf CAS/.git
  && cp -R CAS/* /srv/shiny-server
  && rm -rf CAS/

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# startup process
CMD ["sudo", "-u", "shiny", "/usr/bin/shiny-server"]