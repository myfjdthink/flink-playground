CREATE TABLE t_order (
    order_number BIGINT,
    item_id      BIGINT,
    pad_string   VARCHAR,
    order_time   TIMESTAMP(3),
    proctime AS PROCTIME()
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '1000',  -- 大量数据，看看 flink 内存变化
  'fields.item_id.min'='1',
  'fields.item_id.max'='10',
  'fields.pad_string.length'='1000'
);

CREATE TABLE t_item (
    id BIGINT,
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3)
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '30',
  'fields.id.kind'='sequence',
  'fields.id.start'='1',
  'fields.id.end'='10',
  'fields.item_id.min'='1',
  'fields.item_id.max'='2',
  'fields.price.min'='1',
  'fields.price.max'='10'
);

CREATE TABLE blackhole_table (
  item_id BIGINT,
  pad_string VARCHAR,
  order_time   TIMESTAMP(3),
  price  DECIMAL(32,2)
) WITH (
  'connector' = 'blackhole'
);

SET 'pipeline.name' = 'window_tumble_avoid_oom_2';
SET 'execution.checkpointing.interval' = '20s';
SET 'state.checkpoints.dir' = 'file:///opt/flink_cp';


-- 加上 Window，过期的 Window stage 会自动清除
insert into blackhole_table SELECT
    o.item_id,
    o.pad_string,
    o.order_time,
    avg(t.price) as price
FROM t_order o
LEFT JOIN t_item t ON o.item_id = t.item_id  --LEFT JOIN 了一个 流表，还是会导致 OOM
GROUP BY o.item_id, o.pad_string, o.order_time, TUMBLE(proctime, INTERVAL '20' SECOND);






