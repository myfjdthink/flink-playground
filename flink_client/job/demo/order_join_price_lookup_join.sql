CREATE TABLE t_order (
    order_number BIGINT,
    item_id      BIGINT,
    order_time   TIMESTAMP(3),
    proctime AS PROCTIME()
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '5',
  'fields.order_number.kind'='sequence',
  'fields.order_number.start'='1',
  'fields.order_number.end'='1000000',
  'fields.item_id.min'='1',
  'fields.item_id.max'='7'
);

CREATE TABLE t_item (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3),
    PRIMARY KEY(item_id) NOT ENFORCED      -- (1) 定义主键约束
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:postgresql://pgsql:5432/postgres',
  'lookup.cache.max-rows' = '100',  -- https://nightlies.apache.org/flink/flink-docs-master/docs/connectors/table/jdbc/#lookup-cache
  'lookup.cache.ttl' = '100000',  -- 毫秒
  'username' = 'klg',
  'password' = '123456',
  'table-name' = 'public.item_price'
);

-- https://nightlies.apache.org/flink/flink-docs-master/zh/docs/dev/table/sourcessinks/#%E5%8A%A8%E6%80%81%E8%A1%A8%E7%9A%84-source-%E7%AB%AF
-- lookup join 会不断查询 pgsql by item_id， 关键语法是 FOR SYSTEM_TIME   link https://www.51cto.com/article/711906.html
SELECT
    o.*,
    t.price,
    t.update_time AS price_time
FROM t_order o
LEFT JOIN t_item FOR SYSTEM_TIME AS OF o.proctime AS t
ON o.item_id = t.item_id;




