# ------------------------------
#
# Build for Census At School (CAS)
#
# ------------------------------

FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# install R packages specific to iNZight CAS
RUN apt-get update \
  && apt-get install -q -y git libmysqlclient-dev \
  && R -e "install.packages(c('RMySQL'), repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
  && rm -rf /srv/shiny-server/* \
  && git clone https://github.com/iNZightVIT/CAS.git \
  && rm -rf CAS/.git \
  && cp -R CAS/* /srv/shiny-server \
  && rm -rf CAS/ \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy shiny-server startup script
COPY shiny-server.sh /usr/bin/shiny-server.sh

# make it executable
RUN chmod +x /usr/bin/shiny-server.sh

# startup process
CMD ["/usr/bin/shiny-server.sh"]
