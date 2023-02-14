CREATE TABLE t_item (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3),
    WATERMARK FOR update_time AS update_time
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '3',
  'fields.item_id.min'='1',
  'fields.item_id.max'='5',
  'fields.price.min'='1',
  'fields.price.max'='10000'
);

CREATE VIEW versioned_price AS
SELECT item_id, price, update_time
  FROM (
      SELECT *,
      ROW_NUMBER() OVER (PARTITION BY item_id  -- (2) `item_id` 是去重 query 的 unique key，可以作为主键
         ORDER BY update_time DESC) AS rowNum
      FROM t_item)
WHERE rowNum = 1;


-- 要手动在 PG sql 建表
-- CREATE TABLE IF NOT EXISTS item_price (
--    item_id BIGINT,
--    price DECIMAL(32,2),
--    update_time TIMESTAMP(3),
--    PRIMARY KEY(item_id)
-- );

CREATE TABLE sink_table (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3),
    PRIMARY KEY (item_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://pgsql:5432/postgres',
    'username' = 'klg',
    'password' = '123456',
    'table-name' = 'public.item_price'
);

SET 'pipeline.name' = 'datagen_to_pgsql_unique';
SET 'execution.checkpointing.interval' = '10s';

-- submit job
insert into sink_table select * from versioned_price;
