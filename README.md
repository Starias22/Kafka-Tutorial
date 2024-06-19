# Apache Kafka Tutorial

Apache Kafka is a distributed streaming platform developed at LinkedIn in 2009. It became open source in 2011 and was integrated into the Apache Software Foundation in 2014. Kafka is widely used to create real-time data pipelines and streaming applications. It functions similarly to a messaging system, transferring data from one source to another. This tutorial will guide you through the basics of Kafka and how to set up a Kafka environment.

## Key Concepts

### Kafka Components

1. **Producer**: An application that sends data to Kafka.
2. **Consumer**: An application that receives data from Kafka.
3. **Broker**: A Kafka server that acts as a bridge between producers and consumers.
4. **Topic**: A category or feed name to which records are sent by producers.
5. **Partition**: Subsets of a topic that can be spread across multiple servers for scalability.
6. **Offset**: A unique identifier of a message within a partition.
7. **Consumer Group**: A group of consumers that work together to consume data from the same topic.

### Additional Components

- **Stream Processor**: Reads data from Kafka, processes it, and sends it back to Kafka or other systems.
- **Connectors**: Used to connect Kafka to other data systems like databases for importing or exporting data.

### Fault Tolerance

- **Replication**: Kafka ensures fault tolerance by replicating data across multiple brokers.
- **Replication Factor**: The number of copies of each data.
- **Leader and Followers**: Each partition has a leader, and producers and consumers interact with the leader.

## Setting Up Kafka

### Prerequisites

- Java (JDK 8 or later)
- Scala (compatible version with Kafka)

### Download and Extract Kafka

1. **Download Kafka**:

   ```sh
   wget https://downloads.apache.org/kafka/3.7.0/kafka-3.7.0-src.tgz
   ```

2. **Extract Kafka**:

   ```sh
   tar -xvf kafka-3.7.0-src.tgz
   mv kafka-3.7.0-src.tgz ..
   cd kafka-3.7.0-src
   ```

### Build Kafka

3. **Build Kafka**:

   ```sh
   ./gradlew jar -PscalaVersion=2.13.12
   ```

### Start Zookeeper and Kafka

4. **Start Zookeeper**:

   ```sh
   bin/zookeeper-server-start.sh config/zookeeper.properties
   ```

5. **Start Kafka**:

   ```sh
   bin/kafka-server-start.sh config/server.properties
   ```

### Create and List Kafka Topics

6. **Create a Kafka Topic**:

   ```sh
   bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic MyFirstTopic --partitions 2 --replication-factor 1
   ```

7. **List Kafka Topics**:

   ```sh
   bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
   ```

### Create a Producer and Consumer

8. **Create a Console Producer**:

   ```sh
   bin/kafka-console-producer.sh --broker-list localhost:9092 --topic MyFirstTopic
   ```

9. **Create a Console Consumer**:

   ```sh
   bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic MyFirstTopic
   ```

## Advanced Kafka Setup

### Configure Additional Brokers

1. **Copy Server Configurations**:

   ```sh
   cp config/server.properties config/server-1.properties
   cp config/server.properties config/server-2.properties
   ```

2. **Modify Server Properties**:

   - **Broker ID**: Unique identifier for each broker.
   - **Port**: Different port for each broker in a single machine setup.
   - **Log Directory**: Separate log directories for each broker.

3. **Start Additional Brokers**:

   ```sh
   bin/kafka-server-start.sh config/server-1.properties
   bin/kafka-server-start.sh config/server-2.properties
   ```

### Create a Topic with Replication

4. **Create a Topic with Partitions and Replication**:

   ```sh
   bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic TestTopicXYZ --partitions 2 --replication-factor 3
   ```

5. **Describe the Topic**:

   ```sh
   bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic TestTopicXYZ
   ```

## Broker Configuration

1. **zookeeper.connect**: A hostname and a port number defining a connection string between the brokers.
2. **delete.topic.enable**: Allows deleting topics. Often set to true in development mode and false in production mode.
3. **auto.create.topics.enable**: Decides whether to create a topic if a producer sends a message to a non-existing topic or a consumer tries to retrieve messages from a non-existing topic. It is true by default, but often set to false in production mode.
4. **default.replication.factor**: The default number of replicas for a topic. Default is 1.
5. **num.partitions**: The default number of partitions per topic. Default is 1.
6. **log.retention.ms**: Defines retention by time. Kafka will clean messages when the specified time in milliseconds is reached.
7. **log.retention.bytes**: Defines retention by size. Kafka will clean messages when the specified size is reached. When both `log.retention.ms` and `log.retention.bytes` are specified, Kafka will clean messages when any of the conditions are met.

### Starting Multiple Brokers

1. **Copy Server Configurations**:

   ```sh
   cp config/server.properties config/server-1.properties
   cp config/server.properties config/server-2.properties
   ```

2. **Modify the Following Properties**:

   - **broker.id**: An integer that uniquely identifies each broker.
   - **port**: Ensure different ports for each broker in a single machine setup.
   - **log.dirs**: Define separate log directories for each broker.

3. **Start the Brokers**:

   ```sh
   bin/kafka-server-start.sh config/server-1.properties
   bin/kafka-server-start.sh config/server-2.properties
   ```

4. **Create a Topic with Replication**:

   ```sh
   bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic TestTopicXYZ --partitions 2 --replication-factor 3
   ```

5. **Describe the Topic**:

   ```sh
   bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic TestTopicXYZ
   ```

## Message Sending Methods

### Fire and Forget

Used when it is not critical to lose a small amount of data. It is fast.

```python
from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers='localhost:9092')
producer.send('MyFirstTopic', b'Test Message')
producer.flush()
```

### Synchronous Send

Send and wait for a response. Used when the data is critical; it is slow.

```python
from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers='localhost:9092')
future = producer.send('MyFirstTopic', b'Test Message')
result = future.get(timeout=10)
print(result)
```

### Asynchronous Send

Send and provide a callback function to receive the acknowledgment.

```python
from kafka import KafkaProducer

def on_send_success(record_metadata):
    print(f'Message sent to {record_metadata.topic} partition {record_metadata.partition} offset {record_metadata.offset}')

def on_send_error(excp):
    print(f'I am an errback {excp}')

producer = KafkaProducer(bootstrap_servers='localhost:9092')
producer.send('MyFirstTopic', b'Test Message').add_callback(on_send_success).add_errback(on_send_error)
producer.flush()
```

## Conclusion

This tutorial provided an overview of Apache Kafka, including its key concepts, setup, and advanced configurations. Kafka is a powerful tool for building real-time data pipelines and streaming applications, making it a valuable asset for many organizations. By following this tutorial, you should have a good foundation for working with Kafka.
