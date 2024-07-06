FROM bitnami/spark:3.5.1

# Install curl
USER root
RUN apt-get update && apt-get install -y curl 
# && rm -rf /var/lib/apt/lists/*

# Download Kafka and Pool2 packages for Spark
RUN curl -o /opt/bitnami/spark/jars/spark-sql-kafka-0-10_2.12-3.5.1.jar https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.5.1/spark-sql-kafka-0-10_2.12-3.5.1.jar
RUN curl -o /opt/bitnami/spark/jars/kafka-clients-3.5.1.jar https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/3.5.1/kafka-clients-3.5.1.jar
RUN curl -o /opt/bitnami/spark/jars/commons-pool2-2.11.1.jar https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.11.1/commons-pool2-2.11.1.jar
RUN curl -o /opt/bitnami/spark/jars/spark-token-provider-kafka-0-10_2.12-3.5.1.jar https://repo1.maven.org/maven2/org/apache/spark/spark-token-provider-kafka-0-10_2.12/3.5.1/spark-token-provider-kafka-0-10_2.12-3.5.1.jar

# Set environment variable
ENV PYSPARK_SUBMIT_ARGS="--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1,org.apache.spark:spark-token-provider-kafka-0-10_2.12:3.5.1 pyspark-shell"

# Copy any necessary files
# COPY requirements.txt /opt/requirements.txt
RUN pip install  nltk

# Ensure necessary environment variables are set
# ENV SPARK_HOME /opt/spark

# Set the entrypoint to Spark
# ENTRYPOINT ["/opt/spark/bin/spark-submit"]
