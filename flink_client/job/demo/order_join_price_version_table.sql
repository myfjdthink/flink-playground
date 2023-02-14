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

CREATE TABLE t_item_price_version (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3) METADATA FROM 'value.source.timestamp' VIRTUAL,
    PRIMARY KEY(item_id) NOT ENFORCED,      -- (1) 定义主键约束
    WATERMARK FOR update_time AS update_time   -- (2) 通过 watermark 定义事件时间
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:postgresql://pgsql:5432/postgres',
  'username' = 'klg',
  'password' = '123456',
  'table-name' = 'public.item_price_history'
);

-- 报错，走不通
-- [ERROR] Could not execute SQL statement. Reason:
-- org.apache.flink.table.api.ValidationException: Table 'JDBC:PostgreSQL' declares metadata columns, but the underlying DynamicTableSource doesn't implement the SupportsReadingMetadata interface. Therefore, metadata cannot be read from the given source