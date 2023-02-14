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
  'fields.item_id.max'='8'
);

CREATE TABLE t_item (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3),
    WATERMARK FOR update_time AS update_time
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '2',
  'fields.item_id.min'='1',
  'fields.item_id.max'='5',
  'fields.price.min'='1',
  'fields.price.max'='10000'
);

-- 临时表 join

-- 先定义时态 View
CREATE VIEW versioned_price AS
SELECT item_id, price
  FROM (
      SELECT *,
      ROW_NUMBER() OVER (PARTITION BY item_id  -- (2) `item_id` 是去重 query 的 unique key，可以作为主键
         ORDER BY update_time DESC) AS rowNum
      FROM t_item )
WHERE rowNum = 10;


-- join
-- 注意，如果 order 里的 item 没有 price，将会被过滤，
SELECT
    o.*,
    t.price
FROM t_order o, versioned_price t
WHERE o.item_id = t.item_id
AND o.item_id > 3 AND o.item_id < 7 ;


-- left join
-- 当币价更新是，已经处理过的 t_order 会被重复处理
SELECT
    o.*,
    t.price
FROM t_order o LEFT JOIN versioned_price t on o.item_id = t.item_id;

-- lookup join
-- view 还不支持作为 lookup join 的 source
-- https://nightlies.apache.org/flink/flink-docs-master/zh/docs/dev/table/concepts/versioned_tables/#%E5%A3%B0%E6%98%8E%E7%89%88%E6%9C%AC%E8%A7%86%E5%9B%BE
SELECT
    o.*,
    t.price
FROM t_order o
LEFT JOIN versioned_price FOR SYSTEM_TIME AS OF o.proctime AS t
on o.item_id = t.item_id;

