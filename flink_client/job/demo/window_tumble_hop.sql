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
  'fields.order_number.end'='100',
  'fields.item_id.min'='1',
  'fields.item_id.max'='10'
);


SELECT
    TUMBLE_START(order_time, INTERVAL '5' SECOND) AS window_start,
    TUMBLE_END(order_time, INTERVAL '5' SECOND) AS window_end,
    SUM(1) as cnt
FROM t_order GROUP BY TUMBLE(order_time, INTERVAL '5' SECOND);


CREATE TABLE t_order2 (
    order_number BIGINT,
    item_id      BIGINT,
    order_time   TIMESTAMP(3),
    WATERMARK FOR order_time AS order_time
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '5',
  'fields.order_number.kind'='sequence',
  'fields.order_number.start'='1',
  'fields.order_number.end'='100',
  'fields.item_id.min'='1',
  'fields.item_id.max'='10'
);

SELECT
    HOP_START(order_time, INTERVAL '1' SECOND, INTERVAL '5' SECOND) AS window_start,
    HOP_END(order_time, INTERVAL '1' SECOND, INTERVAL '5' SECOND) AS window_end,
    SUM(1) as cnt
FROM t_order2 GROUP BY HOP(order_time, INTERVAL '1' SECOND, INTERVAL '5' SECOND);




