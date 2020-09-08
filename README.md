## 工作原理

1. mysql-collector-plugin 监控插件包使用了第三方的 MySQL Exporter 进行指标采集，GitHub 链接为 https://github.com/prometheus/mysqld_exporter 。

## 准备工作

1. 确认要采集的 MySQL 具体的 IP、端口。
2. 确认连接 MySQL 的用户和密码，可通过以下命令创建只读用户。

```
CREATE USER 'exporter'@'0.0.0.0' IDENTIFIED BY '123456';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'0.0.0.0';
flush privileges;
```

## 使用方法

### 导入监控插件包

1. 下载该项目的压缩包（https://github.com/easy-monitor/mysql-collector-plugin/archive/master.zip ）。

2. 建议解压到 EasyOps 平台服务器上的 `/usr/local/easyops/monitor_plugin_packages` 该目录下。

3. 使用 EasyOps 平台内置的监控插件包导入工具进行导入，具体命令如下，请替换其中的 `8888` 为当前 EasyOps 平台具体的 `org`。

```sh
$ cd /usr/local/easyops/collector_plugin_service/tools
$ sh plugin_op.sh install 8888 /usr/local/easyops/monitor_plugin_packages/mysql-collector-plugin
```

4. 导入成功后访问 EasyOps 平台的「采集插件」小产品页面 (http://your-easyops-server/next/collector-plugin )，就能看到导入的 "mysql-collector-plugin" 采集插件。

### 启动 MySQL Exporter

1. 启动 MySQL Exporter，具体命令如下，请替换其中的 `--mysql-host`、`--mysql-port` 参数为采集的 MySQL 的监听地址和端口，`--mysql-user`、`--mysql-password` 参数为连接 MySQL 的用户和密码。

```sh
$ cd /usr/local/easyops/monitor_plugin_packages/mysql-collector-plugin/script
$ start_script.sh --mysql-host 127.0.0.1 --mysql-port 3306 --mysql-user exporter --mysql-password 123456
```

2. 通过访问 http://127.0.0.1:9104/metrics 来获取指标数据，请替换其中的 `127.0.0.1:9104` 为 Exporter 具体的监听地址和端口。

```sh
$ curl http://127.0.0.1:9104/metrics 
```

3. 接下来可使用导入的采集插件为具体的资源实例创建采集任务。

## 启动参数

| 名称 | 类型 | 必填 | 默认值 | 说明 |
| --- | --- | --- | --- | --- |
| mysql-host | string | false | 127.0.0.1 | MySQL 监听地址 |
| mysql-port | int | false | 3306 | MySQL 监听端口 |
| mysql-user | string | false |  | MySQL 认证用户 |
| mysql-password | string | false |  | MySQL 认证密码 |
| exporter-host | string | false | 127.0.0.1 | Exporter 监听地址 |
| exporter-port | int | false | 9104 | Exporter 监听端口 |
| exporter-uri | string | false | /metrics | Exporter 获取指标数据的 URI |
