CREATE TABLE t_order (
    order_number BIGINT,
    item_id      BIGINT,
    pad_string   VARCHAR,
    order_time   TIMESTAMP(3)
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '1000',  -- 大量数据，看看 flink 内存变化
  'fields.item_id.min'='1',
  'fields.item_id.max'='10',
  'fields.pad_string.length'='1000'
);

CREATE TABLE blackhole_table (
  item_id BIGINT,
  pad_string VARCHAR,
  order_time   TIMESTAMP(3)
) WITH (
  'connector' = 'blackhole'
);

SET 'pipeline.name' = 'window_tumble_avoid_oom';
SET 'execution.checkpointing.interval' = '30s';
SET 'state.checkpoints.dir' = 'file:///opt/flink_cp';

-- group by 会把 t_order 的历史状态都保存起来，导致 state 越来越大，可以冲 checkpoint history 观察出来
insert into blackhole_table SELECT
    item_id,
    pad_string,
    order_time
FROM t_order GROUP BY item_id, pad_string, order_time;






