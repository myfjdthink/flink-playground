CREATE TABLE t_order (
    order_number BIGINT,
    transaction_hash      BIGINT,
    log_index      BIGINT,
    order_time   TIMESTAMP(3),
    WATERMARK FOR order_time AS order_time -  INTERVAL '5' SECOND
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '10',
  'fields.order_number.kind'='sequence',
  'fields.order_number.start'='1',
  'fields.order_number.end'='10000000',
  'fields.transaction_hash.min'='1',
  'fields.transaction_hash.max'='10',
  'fields.log_index.min'='1',
  'fields.log_index.max'='2'
);

--- https://nightlies.apache.org/flink/flink-docs-master/zh/docs/dev/table/sql/queries/window-topn/
--- 固定写法，照着文档来，一定要把 rownum 字段加上过滤条件，不然 Flink 要保存的状态不确定

WITH table_with_rownum as (
    SELECT * FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY transaction_hash
            ORDER BY log_index
        ) as rownum
    FROM TABLE(TUMBLE(TABLE t_order, DESCRIPTOR(order_time), INTERVAL '5' MINUTES))
    ) WHERE rownum < 3
)

select transaction_hash, COUNT(*) as cnt
from table_with_rownum
group by transaction_hash;

select *, mod(rownum, 2) as order_tye from table_with_rownum;





