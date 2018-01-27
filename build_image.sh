docker build -t jeandet/teamcity_agent_ubuntu_17_10 .
docker run -d=true -e SERVER_URL=https://hephaistos.lpp.polytechnique.fr/teamcity --name=teamcity_agent_ubuntu_17_10 -it jeandet/teamcity_agent_ubuntu_17_10 &
sleep 300
docker stop teamcity_agent_ubuntu_17_10
docker commit teamcity_agent_ubuntu_17_10 jeandet/teamcity_agent_ubuntu_17_10
docker rm teamcity_agent_ubuntu_17_10
