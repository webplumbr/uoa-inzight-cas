# ------------------------------
#
# Build for Census At School (CAS)
#
# ------------------------------

FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# Edit the following environment variable, commit to Github and it will trigger Docker build
# Since we fetch the latest changes from the associated Application~s master branch
# this helps trigger date based build
# The other option would be to tag git builds and refer to the latest tag
ENV LAST_BUILD_DATE="2015-11-30" 

# install R packages specific to iNZight CAS
RUN apt-get update \
  && apt-get install -q -y libmysqlclient-dev libcurl4-openssl-dev \
  && R -e "install.packages(c('RMySQL', 'plyr', 'lattice', 'RCurl', 'RJSONIO', 'whisker', 'yaml'), repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
  && wget -O rCharts.tar.gz https://github.com/ramnathv/rCharts/archive/master.tar.gz \
  && R -e "install.packages('rCharts.tar.gz', repos = NULL)" \
  && rm -rf /srv/shiny-server/* rCharts.tar.gz \
  && wget -O CAS.zip https://github.com/iNZightVIT/CAS/archive/master.zip \
  && unzip CAS.zip \
  && rm -rf CAS.zip \
  && cp -R CAS-master/* /srv/shiny-server \
  && echo $LAST_BUILD_DATE > /srv/shiny-server/build.txt \
  && rm -rf CAS-master/ \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# handle DB config info separately
COPY config.R /srv/shiny-server/

# start shiny server process - it listens to port 3838
CMD ["/opt/shiny-server.sh"]
