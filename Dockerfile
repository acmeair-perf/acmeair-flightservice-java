FROM jboss/wildfly:latest

# Enable Jaeger
ENV JAEGER_SERVICE_NAME=jaeger-service
ENV JAEGER_AGENT_HOST=jaeger
ENV JAEGER_REPORTER_LOG_SPANS=false
ENV JAEGER_SAMPLER_TYPE=const
ENV JAEGER_SAMPLER_PARAM=1

COPY target/acmeair-flightservice-java-4.0.war /opt/jboss/wildfly/standalone/deployments/

# Avoid annoying CDi INFO Message
RUN sed -i 's/<level name="INFO"/<level name="WARN"/' /opt/jboss/wildfly/standalone/configuration/standalone-microprofile.xml

USER 0
RUN chown jboss:0 /opt/jboss/wildfly/standalone/deployments/acmeair-flightservice-java-4.0.war
USER jboss

ENV KEYSTORE_LOCATION=/opt/boss/wildfly/key.p12

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-c","standalone-microprofile.xml","-b", "0.0.0.0", "-bmanagement", "0.0.0.0","-Djboss.http.port=9080"]
