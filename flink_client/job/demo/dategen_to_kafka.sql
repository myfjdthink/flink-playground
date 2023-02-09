CREATE TABLE `default_catalog`.`default_database`.`source_table` (
    order_number BIGINT,
    price        DECIMAL(32,2),
    order_time   TIMESTAMP(3),
    WATERMARK FOR order_time AS order_time
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '10',
  'fields.order_number.kind'='sequence',
  'fields.order_number.start'='1',
  'fields.order_number.end'='1000',
  'fields.price.min'='1',
  'fields.price.max'='10000'
);

CREATE TABLE `default_catalog`.`default_database`.`sink_table` (
    order_number BIGINT,
    price        DECIMAL(32,2),
    order_time   TIMESTAMP(3),
    WATERMARK FOR order_time AS order_time
) WITH (
    'connector' = 'kafka',
    'topic' = 'test_sink',
    'properties.bootstrap.servers' = '10.202.0.79:9092',
    'properties.group.id' = 'flink_demo_kafka_to_kafka',
    'format' = 'json'
);

-- submit job
insert into sink_table
select * from source_table;
