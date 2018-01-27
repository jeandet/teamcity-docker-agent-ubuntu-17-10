FROM ubuntu:17.10
#Derived from official TeamCity image
LABEL modified "Alexis Jeandet <alexis.jeandet@member.fsf.org>"

RUN apt update && apt install -y openjdk-8-jdk mercurial git cmake tar gzip unzip xvfb g++ lsb-release qt5-default build-essential qttools5-dev qttools5-dev-tools
RUN apt install -y pandoc libnetpbm10-dev libhdf5-dev libfftw3-dev python-dev libhdf4-dev libtiff5-dev libgsl-dev qtmultimedia5-dev libqt5svg5-dev libqt5scripttools5 qtscript5-dev libqt5multimediawidgets5 libcfitsio-dev libhdf4-dev libhdf5-dev libhdf5-100 python-numpy

VOLUME /data/teamcity_agent/conf
ENV CONFIG_FILE=/data/teamcity_agent/conf/buildAgent.properties \
    TEAMCITY_AGENT_DIST=/opt/buildagent

RUN mkdir $TEAMCITY_AGENT_DIST

ADD https://teamcity.jetbrains.com/update/buildAgent.zip $TEAMCITY_AGENT_DIST/
RUN unzip $TEAMCITY_AGENT_DIST/buildAgent.zip -d $TEAMCITY_AGENT_DIST/

LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

COPY run-agent.sh /run-agent.sh
COPY run-services.sh /run-services.sh

RUN useradd -m buildagent && \
    chmod +x /run-agent.sh /run-services.sh && \
    rm $TEAMCITY_AGENT_DIST/buildAgent.zip && \
    sync
#add line return for derived images
RUN echo " " >> /opt/buildagent/conf/buildAgent.dist.properties && \
    echo "system.distrib=ubuntu" >> /opt/buildagent/conf/buildAgent.dist.properties && \
    echo "system.agent_name=ubuntu-17-10" >> /opt/buildagent/conf/buildAgent.dist.properties  && \
    echo "system.agent_repo=https://github.com/jeandet/teamcity-docker-agent-ubuntu-17-10" >> /opt/buildagent/conf/buildAgent.dist.properties

CMD ["/run-services.sh"]

EXPOSE 9090
