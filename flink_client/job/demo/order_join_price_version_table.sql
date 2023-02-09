CREATE TABLE t_order (
    order_number BIGINT,
    item_id      BIGINT,
    order_time   TIMESTAMP(3),
    WATERMARK FOR order_time AS order_time
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '5',
  'fields.order_number.kind'='sequence',
  'fields.order_number.start'='1',
  'fields.order_number.end'='1000000',
  'fields.item_id.min'='1',
  'fields.item_id.max'='10'
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

-- Interval Join window join 会 1 * N，存在重复数据，因为在一个时间窗口内，item price 会有多个
-- SELECT
--     o.*,
--     t.price
-- FROM t_order o, t_item t
-- WHERE o.item_id = t.item_id
-- AND o.item_id > 1 AND o.item_id < 4
-- AND t.update_time BETWEEN o.order_time - INTERVAL '1' MINUTE AND o.order_time;


-- left join 写法，问题同上
-- SELECT
--     o.*,
--     t.price
-- FROM t_order o LEFT JOIN t_item t on o.item_id = t.item_id
-- AND t.update_time BETWEEN o.order_time - INTERVAL '1' MINUTE AND o.order_time
-- WHERE o.item_id > 1 AND o.item_id < 4;


-- 临时表 join

-- 先定义时态表
CREATE VIEW versioned_price AS
SELECT item_id, price, update_time            -- (1) `currency_time` 保留了事件时间
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
SELECT
    o.*,
    t.price
FROM t_order o LEFT JOIN versioned_price t on o.item_id = t.item_id
WHERE o.item_id > 3 AND o.item_id < 7;

