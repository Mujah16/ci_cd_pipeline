FROM iamdevopstrainer/tomcat:base
COPY xyz_tech.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]