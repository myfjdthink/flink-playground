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
SELECT
    o.*,
    t.price
FROM t_order o, t_item t
WHERE o.item_id = t.item_id
AND o.item_id > 1 AND o.item_id < 4
AND t.update_time BETWEEN o.order_time - INTERVAL '1' MINUTE AND o.order_time;


-- left join 写法，问题同上
-- SELECT
--     o.*,
--     t.price
-- FROM t_order o LEFT JOIN t_item t on o.item_id = t.item_id
-- AND t.update_time BETWEEN o.order_time - INTERVAL '1' MINUTE AND o.order_time
-- WHERE o.item_id > 1 AND o.item_id < 4;

-- 可以考虑对结果在进一步做 group by 去重，只选最新值


