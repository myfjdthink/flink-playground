###############################################################################
# Build SQL Playground Image
###############################################################################

FROM apache/flink:1.16-scala_2.12
ARG FLINK_VERSION=1.16.0


# Download connector libraries
RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/${FLINK_VERSION}/flink-sql-connector-kafka-${FLINK_VERSION}.jar;

RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc/${FLINK_VERSION}/flink-connector-jdbc-${FLINK_VERSION}.jar;
RUN wget -P /opt/flink/lib/ https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.5/postgresql-42.2.5.jar;

RUN mkdir -p /opt/sql-client/
RUN mkdir -p /opt/sql-client/lib
# Copy sql-client shell
COPY sql-client/ /opt/sql-client/
ENV SQL_CLIENT_HOME /opt/sql-client/

CMD tail -f /dev/null