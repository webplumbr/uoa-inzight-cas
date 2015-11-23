# ------------------------------
#
# Build for Census At School (CAS)
#
# ------------------------------

#FROM scienceis:uoa-inzight-base:latest
FROM uoa-inzight-base:tom

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

## list all necessary packages here:
ENV R_PACKAGES '"RMySQL", "plyr", "lattice", "RCurl", "whisker", "yaml"'

# install R packages specific to iNZight CAS
RUN apt-get update \
  && apt-get install -q -y libmysqlclient-dev libcurl4-openssl-dev \
  && R -e "install.packages(c(${R_PACKAGES}), repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
  && wget -O rCharts.tar.gz https://github.com/ramnathv/rCharts/archive/master.tar.gz \
  && R -e "install.packages('rCharts.tar.gz', repos = NULL)" \
  && rm -rf /srv/shiny-server/* rCharts.tar.gz \
  && wget -O CAS.zip https://github.com/iNZightVIT/CAS/archive/master.zip \
  && unzip CAS.zip \
  && rm -rf CAS.zip \
  && cp -R CAS-master/* /srv/shiny-server \
  && rm -rf CAS-master/ \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy shiny-server startup script
#COPY shiny-server.sh /usr/bin/shiny-server.sh

# make it executable
#RUN chmod +x /usr/bin/shiny-server.sh

# startup process
#CMD ["/usr/bin/shiny-server.sh"]
#CMD ["sudo", "-u", "shiny", "shiny-server"]
