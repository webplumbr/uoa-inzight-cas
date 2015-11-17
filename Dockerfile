# ---------------------------------------------
#
# Dockerfile best practices
# Refer: http://docs.docker.com/engine/articles/dockerfile_best-practices/
#
# For information on the phusion baseimage
# Refer: https://phusion.github.io/baseimage-docker/
#
# ---------------------------------------------

FROM scienceis/inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# install CAS specific packages
RUN apt-get -y install --no-install-recommends \
    libcurl4-openssl-dev \
    libxml2-dev \
    libmysqlclient-dev

# install R packages
RUN R -e "install.packages(c('RMySQL'), repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
    && R -e "devtools::install_github('ramnathv/rCharts')"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy shiny-server startup script
COPY shiny-server.sh /usr/bin/shiny-server.sh

# make it executable
RUN chmod +x /usr/bin/shiny-server.sh

# startup process
CMD ["/usr/bin/shiny-server.sh"]