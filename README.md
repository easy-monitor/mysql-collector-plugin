# EasyOps MySQL 监控插件包

EasyOps MySQL 监控插件包是适用于 EasyOps 新版监控平台，专门提供 MySQL 监控服务的官方插件包。它提供了对 MySQL 的常见监控指标进行采集的采集插件以及可视化的仪表盘展示。

## 目录

- [背景](#背景)
- [适用环境](#适用环境)
- [工作原理](#工作原理)
- [准备工作](#准备工作)
- [使用方法](#使用方法)
- [维护者](#维护者)
- [许可证](#许可证)

## 背景

由于目前在 EasyOps 新版监控平台上搭建 MySQL 监控场景需要经过以下步骤：

1. 自行搜索 MySQL Exporter 并调试配置。
2. 在插件中心创建采集插件，使用步骤1输出的指标数据录入监控指标。
3. 使用创建的采集插件为具体的资源实例创建采集任务。
4. 理解监控指标含义后配置仪表盘展示。

所以为了实现 MySQL 监控场景的快速搭建，该项目对 MySQL 一些常见的监控指标及其采集脚本进行了封装，同时提供一个基本的仪表盘展示。

用户能够借助 EasyOps 平台提供的自动化工具来一键导入该插件包，真正做到 MySQL 监控场景的开箱即用。

## 适用环境

MySQL >= 5.1

## 工作原理

1. MySQL 监控插件包使用了第三方的 MySQL Exporter 进行指标采集，该 Exporter 的 GitHub 链接为 https://github.com/prometheus/mysqld_exporter 。

## 准备工作

1. 确认采集的 MySQL 实例具体的监听地址和端口。
2. 确认用来连接 MySQL 的用户和密码。该用户至少需要具备 `PROCESS`（用于查看所有用户线程和连接状态）、`REPLICATION CLIENT`（用于查看主从同步状态）、对所有库表的 `SELECT`（用于查看表状态）的权限，可通过以下命令创建仅具有所需权限的用户。

```
CREATE USER 'exporter'@'%' IDENTIFIED BY '123456';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
flush privileges;
```

## 使用方法

### 导入监控插件包

1. 进入[Releases页面](https://github.com/easy-monitor/mysql-collector-plugin/releases)下载该项目的最新版本

2. 建议解压到 EasyOps 平台服务器上的 `/data/exporter` 目录下。

3. 使用 EasyOps 平台提供的自动化工具一键导入该插件包，具体命令如下，请替换其中的 `8888` 为当前 EasyOps 平台具体的 `org`。

```sh
$ cd /usr/local/easyops/collector_plugin_service/tools
$ sh plugin_op.sh install 8888 /data/exporter/mysql-collector-plugin
```

4. 导入成功后访问 EasyOps 平台的「采集插件」列表页面 ( http://your-easyops-server/next/collector-plugin )，就能看到导入的 "mysql_collector_plugin" 采集插件。

### 建立资源模型
* 如果使用我们标准的模型，可以在模型管理里面导入如下文件[MYSQL_SERVICE_NODE.json](./MYSQL_SERVICE_NODE.json)
* 如果使用现场自定义的模型，则修改该模型：
  * 手动添加一个exporter结构体，具备如下字段

    | 字段名 | 类型 | 描述 |
    | - | - | - |
    | protocol | enum | http或https |
    | host | string | exporter所在机器IP |
    | port | number | exporter监听端口 |
    | uri | string | exporter的metrics uri，一般为/metrics |
    | pid | number | exporter启动pid |
    | startCommand | string | 采集插件包的启动命令 |

  * 新加入isMonitor字段，bool型
    用来做是否监控的开关，默认在插件包的`conf.default.yaml`都会有cmdb_query去过滤isMonitor=true的实例

### 启动插件包

1. 根据现场的情况修改`supervisor/exporter-supervisor.py`的`ORG`和`CMDB_HOST`配置

2. 如果现场用的不是内置的`MYSQL_SERVICE_NODE`模型，则修改如下文件：deploy/start_script.sh
```shell
./supervisor/exporter-supervisor.py YOUR-OBJECT-ID
```

3. 启动插件包
有两种方案：

    a. 手动执行：
    ```shell
    cd script
    sh deploy/start_script.sh
    ```

    b. 通过优维的部署平台执行：
    在上述导入那个步，其实就已经将插件包上传到平台的制品包，你可以在程序包管理看到该制品包，程序包的包名为：`collector_plugin-xxx`，按标准的主机部署的方式执行即可，这边不再详细描述。


## 维护者

@easyopscyrilchen

## 许可证

[MIT](#许可证) © EasyOps
