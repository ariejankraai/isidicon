FROM debian:jessie
MAINTAINER Arie Jan Kraai <ariejankraai@persijn.net>
LABEL version="1.0"
LABEL description="First publicly available version"
# LABEL version="0.6 Using supervisord with autorestart = false to enable automated startups"

# Note: containers running the Isilon Data Insights connector depend on influxdb and grafana containers
### TODO:
# Creating the pid cfg and log folders does not work correctly

### DONE:
# Run the program as an ordinairy user -> for now a su on the start-line is used

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get -y install supervisor python python-pip git curl wget less psmisc rsyslog \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/isilon_data_insights_connector

# Define a location for the software, clone the project and pull dependencies in:
RUN mkdir -p /opt && cd /opt
RUN git clone https://github.com/Isilon/isilon_data_insights_connector .
RUN pip install -r ./requirements.txt
RUN mkdir -p /var/log/supervisor
RUN cd $WORKDIR; mkdir -p pid log cfg

COPY supervisoradd.conf /etc/supervisor/conf.d/supervisoradd.conf
COPY example_isi_data_insights_d.cfg example_isi_data_insights_d.cfg

RUN addgroup isidicon && adduser --disabled-password --home /opt/isilon_data_insights_connector --gecos 'Isilon Data Insights' --ingroup isidicon isidicon
RUN chown -R isidicon:isidicon /opt/isilon_data_insights_connector
RUN chmod 2770 /opt/isilon_data_insights_connector

ENTRYPOINT ["/usr/bin/supervisord"]
