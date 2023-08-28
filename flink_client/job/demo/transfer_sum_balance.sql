CREATE TABLE transfers (
    collection      BIGINT,
    item_id      BIGINT,
    tx_amount   BIGINT,
    order_time   TIMESTAMP(3),
    proctime AS PROCTIME()
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '10',
  'fields.item_id.min'='1',
  'fields.item_id.max'='3',
  'fields.collection.min'='1000',
  'fields.collection.max'='1005',
  'fields.tx_amount.min'='0',
  'fields.tx_amount.max'='2'
);

CREATE TABLE blackhole_table (
  order_number BIGINT,
  item_id BIGINT,
  pad_string VARCHAR,
  order_time   TIMESTAMP(3),
  proctime AS PROCTIME()
) WITH (
  'connector' = 'blackhole'
);

SET 'pipeline.name' = 'transfer_sum_balance';
SET 'execution.checkpointing.interval' = '600s';
SET 'state.checkpoints.dir' = 'file:///opt/flink_cp';

-- balance
select
    collection,
    item_id,
    sum(tx_amount) as balance
from TABLE(CUMULATE(TABLE transfers, DESCRIPTOR(proctime), INTERVAL '1' MINUTES, INTERVAL '5' MINUTES))
group by collection, item_id;
order by collection, item_id;
