CREATE TABLE sink_table (
    item_id    BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3),
    PRIMARY KEY (item_id) NOT ENFORCED
) WITH (
    'topic' = 'item_price_sink',
    'properties.bootstrap.servers' = 'broker:9092',
    'connector' = 'upsert-kafka',
    'properties.group.id' = 'a',
    'key.format' = 'json',
    'key.json.ignore-parse-errors' = 'true',
    'value.format' = 'json',
    'value.json.fail-on-missing-field' = 'false'
);

SET 'pipeline.name' = 'kafka_upsert_read';
SET 'execution.checkpointing.interval' = '10s';

-- submit job
select * from sink_table;
