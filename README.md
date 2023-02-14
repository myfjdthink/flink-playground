# Flink Playground

Flink Demo 

两大部分

- flink sql
- pyflink todo

fork https://github.dev/apache/flink-playgrounds

## Install

自行安装 docker + docker-compose

启动服务
```shell
docker compose up -d
```

访问  http://localhost:8081/

可以看到 Flink 的管理界面，点击左侧 task manager 菜单，有内容则说明所有服务正常


## 初始化数据
skip

## 调试 sql

打开 flink sql 调试界面
```shell
docker-compose exec jobmanager bash /opt/sql-client/sql-client.sh
```
可以看到 sql 界面，在这里就可以调试你的 sql 了。

## submit sql job

```shell
docker-compose exec jobmanager bash /opt/sql-client/sql-submit.sh demo/xxx.sql
docker-compose exec jobmanager bash /opt/sql-client/sql-submit.sh demo/datagen_to_kafka.sql
docker-compose exec jobmanager bash /opt/sql-client/sql-submit.sh demo/datagen_to_pgsql.sql
```
就可以将 sql job 提交到 flink。

## sql job demo

### order join price 系列
假设我们有一张 order table，记录了下单时间 order_time 和对应商品 item_id
```sql
CREATE TABLE t_order (
    order_number BIGINT,
    item_id      BIGINT,
    order_time   TIMESTAMP(3)
)
```

有一张 item 表, 记录了商品价格，是会不断变化的
```sql
CREATE TABLE t_item (
    item_id BIGINT,
    price        DECIMAL(32,2),
    update_time   TIMESTAMP(3)
)
```

我们需要计算出 order 生成时对应的 price，典型的  Stream Join Stream，有几种解决方案


1. order_join_price_temporal_join.sql
将 price 变成一个 view，只存储最新 price，方便 order join 币价


- 优点：内存消耗少
- 缺点：币价迟到，会导致 order price 计算有误差


2. order_join_price_window_join.sql
每个 order 都对应一个 price window，找到最时间最近的价格即可


- 优点：大部分情况下，可以拿到最接近 order time 的 price
- 缺点：order 迟到或者 price 迟到，window 数据不存在了，数据会被忽略


3. order_join_price_version_table.sql
效果和方案1相同，不一样的实现方式  