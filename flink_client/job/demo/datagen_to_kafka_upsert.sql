CREATE TABLE t_item (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3)
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '3',
  'fields.item_id.min'='1',
  'fields.item_id.max'='5',
  'fields.price.min'='1',
  'fields.price.max'='10000'
);

CREATE TABLE sink_table (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3),
    PRIMARY KEY (item_id) NOT ENFORCED
) WITH (
    'connector' = 'upsert-kafka',
    'topic' = 'item_price_sink',
    'properties.bootstrap.servers' = 'broker:9092',
    'key.format' = 'json',
    'key.json.ignore-parse-errors' = 'true',
    'value.format' = 'json',
    'value.json.fail-on-missing-field' = 'false'
);


SET 'pipeline.name' = 'datagen_to_kafka_upsert';
SET 'execution.checkpointing.interval' = '10s';

-- submit job
insert into sink_table select * from t_item;
