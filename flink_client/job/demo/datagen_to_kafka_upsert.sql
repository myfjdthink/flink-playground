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

-- CREATE VIEW versioned_price AS
-- SELECT item_id, price, update_time
--   FROM (
--       SELECT *,
--       ROW_NUMBER() OVER (PARTITION BY item_id  -- (2) `item_id` 是去重 query 的 unique key，可以作为主键
--          ORDER BY update_time DESC) AS rowNum
--       FROM t_item)
-- WHERE rowNum = 1;

-- CREATE TABLE sink_table (
--     item_id BIGINT,
--     price        DECIMAL(32,2),
--     update_time   TIMESTAMP(3),
--     PRIMARY KEY (item_id) NOT ENFORCED
-- ) WITH (
--     'connector' = 'upsert-kafka',
--     'topic' = 'test_sink',
--     'properties.bootstrap.servers' = 'broker:9092',
--     'properties.group.id' = 'flink_demo_datagen_to_kafka',
--     'key.format' = 'json',
--     'key.json.ignore-parse-errors' = 'true',
--     'value.format' = 'json',
--     'value.json.fail-on-missing-field' = 'false',
--     'value.fields-include' = 'EXCEPT_KEY'
-- );

CREATE TABLE sink_table (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3)
) WITH (
    'connector' = 'kafka',
    'topic' = 'test_kafka_sink',
    'properties.bootstrap.servers' = 'broker:9092',
    'format' = 'json'
);

SET 'pipeline.name' = 'datagen_to_kafka';
SET 'execution.checkpointing.interval' = '10s';

-- submit job
insert into sink_table select * from t_item;
