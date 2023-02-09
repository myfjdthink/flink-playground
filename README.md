# Flink Playground

Flink Demo 

两大部分

- flink sql
- pyflink todo

## Install

自行安装 docker + docker-compose

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
docker-compose exec jobmanager bash /opt/sql-client/sql-client.sh
```
可以看到 sql 界面，在这里就可以调试你的 sql 了。

## submit sql job

就可以将 sql job 提交到 flink。
