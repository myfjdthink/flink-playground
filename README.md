# Flink Playground

Flink Demo 

两大部分

- flink sql
- pyflink

## Install

自行安装 docker + docker-compose

注意新版 docker 已经自带了 docker compose

启动服务
```shell
docker compose up -d
```

访问  http://localhost:8081/

可以看到 Flink 的管理界面，点击左侧 task manager 菜单，有内容则说明所有服务正常


## 初始化数据

## 调试 sql

打开 flink sql 调试界面
```shell
docker-compose exec sql-client bash /opt/sql-client/sql-client.sh
```
可以看到 sql 界面，在这里就可以调试你的 sql 了。

## submit sql job

就可以将 sql job 提交到 flink。


## Flink SQL 解析
submit job 之后 flink 会做什么？

直接看一个例子，是将 ethereum 的 transactions 数据同步到 iceberg 上，我们可以编写以下  SQL
```sql

-- Define iceberg catalog
CREATE CATALOG iceberg WITH (
  'type'='iceberg',
  'catalog-type'='hive',
  'uri'='thrift://10.106.192.22:9083',  -- hive metastore 地址
  'clients'='5',
  'property-version'='1',
  'warehouse'='gs://footbase-prod/hive-warehouse'
);

-- Define table
CREATE TABLE kf_ethereum_transactions
(
   hash STRING,
   nonce bigint,
   transaction_index bigint,
   from_address varchar,
   to_address STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'chain_data_ethereum_transactions', -- 消息队列名称
    'properties.bootstrap.servers' = '10.202.0.114:9092',  -- kafka 地址
    'properties.group.id' = 'flink_read_group', -- kafka 消费 group，随便写
    'format' = 'json', -- 消息数据格式
    'scan.startup.mode' = 'group-offsets',  -- 消息读取模式，从设定的分组里面已读的topic的偏移值开始读取.
    'json.fail-on-missing-field' = 'false', 
    'json.ignore-parse-errors' = 'true'  -- 很重要，无法解析的字段置为 null
);

-- 设置 checkpoint 触发数据写入 iceberg
SET 'execution.checkpointing.interval' = '4min';
-- 自定义 job name
SET 'pipeline.name' = 'ethereum_transactions_sync';


-- 将数据写入 iceberg，要提前在 iceberg 上建好 table
insert into iceberg.beta_bronze.ethereum_transactions
select * from kf_ethereum_transactions;
```