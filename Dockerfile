FROM iamdevopstrainer/tomcat:base
COPY xyz_tech.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]