FROM tomcat:9.0.41-jdk11
VOLUME /tmp/volume
COPY fileshare.war /tmp/volume/
ADD fileshare.war /usr/local/tomcat/webapps
RUN mv /usr/local/tomcat/webapps/fileshare.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh","run"]