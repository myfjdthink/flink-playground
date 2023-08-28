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

-- pg建表语句
-- CREATE TABLE public.item_amount (
--   collection BIGINT,
--   item_id BIGINT,
--   amount BIGINT,
--   update_time TIMESTAMP(3),
--   PRIMARY KEY(collection, item_id)
-- );
CREATE TABLE item_amount (
    collection      BIGINT,
    item_id      BIGINT,
    amount        BIGINT,
    update_time   TIMESTAMP(3),
    PRIMARY KEY(collection, item_id) NOT ENFORCED      -- (1) 定义主键约束
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:postgresql://pgsql:5432/foot',
  'lookup.cache.max-rows' = '1000',  -- https://nightlies.apache.org/flink/flink-docs-master/docs/connectors/table/jdbc/#lookup-cache
  'lookup.cache.ttl' = '5000',  -- 毫秒
  'username' = 'klg',
  'password' = '123456',
  'table-name' = 'public.item_amount'
);

-- pg建表语句
-- CREATE TABLE public.total_balance (
--   collection BIGINT,
--   item_id BIGINT,
--   total_balance BIGINT,
--   update_time TIMESTAMP(3),
--   PRIMARY KEY(collection, item_id)
-- );
CREATE TABLE sink_table (
    collection BIGINT,
    item_id BIGINT,
    total_balance BIGINT,
    update_time TIMESTAMP(3),
    PRIMARY KEY (collection, item_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://pgsql:5432/foot',
    'username' = 'klg',
    'password' = '123456',
    'table-name' = 'public.total_balance'
);

SET 'pipeline.name' = 'transfer_sum_balance';
SET 'execution.checkpointing.interval' = '60s';
SET 'state.checkpoints.dir' = 'file:///opt/flink_cp';

insert into sink_table SELECT
    collection,
    item_id,
    total_balance,
    update_time
FROM (
    -- balance
    with balance as (
        select collection,
            item_id,
            min(proctime) as proctime,
            sum(tx_amount) as balance
        from TABLE(CUMULATE(TABLE transfers, DESCRIPTOR(proctime), INTERVAL '1' MINUTES, INTERVAL '1' MINUTES))
        where proctime >= 28号
        group by collection, item_id
    )
    ,total_amount as (
        SELECT
            b.collection,
            b.item_id,
            t.amount,
            b.balance,
            b.proctime as update_time,
            COALESCE(t.amount, 0) + b.balance as total_balance,
            t.update_time AS snapshot_time
        FROM balance b
        LEFT JOIN item_amount FOR SYSTEM_TIME AS OF b.proctime AS t
        ON b.item_id = t.item_id and b.collection = t.collection
    )
    select * from total_amount
);
