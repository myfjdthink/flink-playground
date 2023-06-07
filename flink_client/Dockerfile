###############################################################################
# Build SQL Playground Image
###############################################################################

FROM apache/flink:1.16-scala_2.12
ARG FLINK_VERSION=1.16.0

# Install python3.7 and pyflink
# Pyflink does not yet function with python3.9, and this image is build on
# debian bullseye which ships with that version, so build python3.7 here.
RUN set -ex; \
  apt-get update && \
  apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libffi-dev lzma liblzma-dev && \
  wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz && \
  tar -xvf Python-3.7.9.tgz && \
  cd Python-3.7.9 && \
  ./configure --without-tests --enable-shared && \
  make -j4 && \
  make install && \
  ldconfig /usr/local/lib && \
  cd .. && rm -f Python-3.7.9.tgz && rm -rf Python-3.7.9 && \
  ln -s /usr/local/bin/python3 /usr/local/bin/python && \
  ln -s /usr/local/bin/pip3 /usr/local/bin/pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


RUN python -m pip install --upgrade pip; \
  pip install apache-flink==${FLINK_VERSION}; \
  pip install eth_event==1.2.3;

# Download connector libraries
RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/${FLINK_VERSION}/flink-sql-connector-kafka-${FLINK_VERSION}.jar;

RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc/${FLINK_VERSION}/flink-connector-jdbc-${FLINK_VERSION}.jar;
RUN wget -P /opt/flink/lib/ https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.5/postgresql-42.2.5.jar;

RUN mkdir -p /opt/sql-client/
RUN mkdir -p /opt/sql-client/lib


# Copy sql-client shell
# COPY sql-client/ /opt/sql-client/
ENV SQL_CLIENT_HOME /opt/sql-client/

ADD log4j.properties /opt/flink/conf/log4j.properties

CMD tail -f /dev/null