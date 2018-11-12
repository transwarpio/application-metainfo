# TDH 5.0服务标准化开发手册


## 简介
在TDH 5.0中，Transwarp Manager使用标准化的接口管理服务。将已经开发的服务产品化，使其能通过Manager部署和运维，需要提供：

1. 服务元信息
2. 标准化的服务image

下面详细先介绍它们的对接标准，在最后介绍一些调试方法。

## 服务元信息的目录结构
服务的开发者需要提供和维护服务的元信息。在Transwarp Manager安装后，所有服务的元信息被复制到Manager节点的/var/lib/transwarp-manager/master/content/meta/services目录下，每个服务的每一个版本都有一个独立的目录，例如Inceptor的服务元信息的目录位于/var/lib/transwarp-manager/master/content/meta/services/INCEPTOR/<版本号>。

以Inceptor为例，其服务元信息目录的内容结构如下：

```
├── metainfo.yaml
├── configuration.yaml
├── templates
│   ├── hive-env.sh.ftl
│   ├── hive-log4j.properties.raw
│   ├── hive-site.xml.ftl
│   ├── log4j.properties.raw
│   ├── my.cnf.ftl
│   └── ngmr-env.sh.ftl
├── i18n
│   ├── service_en_US.properties
│   └── service_zh_CN.properties
├── resources
│    ├── images
│    │   ├── icon-danger.png
│    │   └── icon-default.png
│    └── summary.json
└── upgrade
    └── rolling_from_5.0.yaml
```

metainfo.yaml称为“服务模板”，包含了服务最基本的定义、角色定义、部署操作、健康检查、一些前端布局信息等；
configuration.yaml称为“配置模板”，包含了可通过Manager配置的服务的配置项；
templates目录存放的是配置文件的模板，Manager在部署服务的过程中根据各类设定渲染这些模板，最终生成配置文件；
i18n目录里面存放的是i18n文件，是各类需要国际化的字段，如包含服务的描述、配置项的描述等；
resources目录里存放静态资源文件，这些文件前端页面可以直接访问，用于辅助服务页面的布局。目前images目录中包含服务的图标，summary.json定义了服务Summary页面的布局。
upgrade目录存放服务升级相关的信息；

后续章节将详细介绍以上文件的编写方法。

## 服务的元数据
### 服务基本定义
服务的基本定义在metainfo.yaml中指定，主要包括以下字段：

| 字段  | 用途 | 示例 |
|---|---|---|
| name | 服务的标识符，只能包含大写字母和下划线 | INCEPTOR |
| version | 服务的版本 | 5.0.0 |
| global | 服务是否为全局服务。若为全局服务，当前Transwarp Manager管理的所有集群中只能有一个该服务的实例。目前只有REGISTRY、TOS、DASHBOARD、LICENSE_SERVICE、GUARDIAN是全局服务 | false |
| namePrefix | 为服务实例自动生成名称时的前缀，由每个单词首字母大写的大小写字母组成 | ZooKeeper、Inceptor |
| friendlyName | 显示在前端的表示服务类型的单词，可出现大小写字母、空格等 | "Inceptor"、"License Service" |
| product | 在首次安装向导中，服务所属的TDH产品系列，若不属于任何产品，则省略该字段 | TOS、Hadoop、Hyperbase、Studio、Inceptor、Stream、Discover、Sophon |

### 服务的依赖
服务的依赖在metainfo.yaml的dependencies字段指定，内容为一个数组，数组的每个元素指定一个依赖项。每个依赖项包含以下字段：

| 字段  | 用途 |
|---|---|
| name | 依赖的服务的标识符 |
| minVersion | 依赖的服务的最低版本 |
| maxVersion | 依赖的服务的最高版本 |
| optional | boolean值，若依赖项为必选则为false，若依赖项为可选则为true |
| preferred | boolean值，当optional为true时有效。true表示创建服务时，Manager自动推荐一个符合要求的已添加服务作为依赖（缺省）；false表示不自动推荐 |

下面是当前Inceptor的metainfo.yaml的dependencies字段
```yaml
dependencies:
  - name: ZOOKEEPER
    minVersion: 3.4.5-tdh50
    maxVersion: 3.4.5-tdh50
    optional: false
  - name: HDFS
    minVersion: 2.5.2-tdh50
    maxVersion: 2.5.2-tdh50
    optional: false
  - name: YARN
    minVersion: 2.5.2-tdh50
    maxVersion: 2.5.2-tdh50
    optional: false
  - name: HYPERBASE
    minVersion: 1.0-tdh50
    maxVersion: 1.0-tdh50
    optional: true
  - name: TXSQL
    minVersion: 1.0-tdh500
    maxVersion: 1.0-tdh500
    optional: false
  - name: INCEPTOR
    minVersion: 4.3-tdh50
    maxVersion: 4.3-tdh50
    optional: true
    preferred: false
  - name: SEARCH
    minVersion: 1.0-tdh50
    maxVersion: 1.0-tdh50
    optional: true
    preferred: true
  - name: RUBIK
    minVersion: 1.0-tdh50
    maxVersion: 1.0-tdh50
    optional: true
    preferred: true
```
创建服务时，Manager会根据已经安装的服务情况为新服务推荐依赖；在添加服务向导中也可以修改依赖；服务安装完成后，也可通过服务页面的“更新依赖”功能修改依赖。
在选择依赖页面的下拉框前默认提示标签为“依赖的\*\*\*”，若要显示一些特殊意义的提示标签，需要在i18n目录下的国际化文件中添加`dependency.title.${依赖服务的标识符}`字段，例如INCETPOR服务，选择依赖其它Inceptor的下列框前提示标签为“共享MetaStore”，因此，在i18n/service_en_US.properties中添加了
```
dependency.title.INCEPTOR=share MetaStore with
```
，在i18n/service_zh_CN.properties中添加了
```
dependency.title.INCEPTOR=\u5171\u4EABMetaStore
```

### 服务的角色
服务的角色在metainfo.yaml的roles字段指定，该字段每一个元素为一种角色类型，每一个角色类型主要包含下列字段：

| 字段 | 用途 | 示例 |
|---|---|---|
| name | 角色类型的标识符，只能包含大写字母或下划线 | INCEPTOR_METASTORE |
| friendlyName | 前端页面上显示的角色的名称 | "Inceptor Metastore" |
| labelPrefix | 部署、启动角色时，用于生成该种角色的启停脚本、container名称、Pod名称等时使用的前缀，只能包含小写字母或连字符，详见“启动服务”节 | "inceptor-metastore" |
| category | 角色的分类，目前包含MASTER和SLAVE两种。在添加节点向导结束时，会提示在新节点上添加已有服务的SLAVE角色，Manager只需简单的执行安装、配置、启动的操作，新添加的SLAVE角色即可使用；MASTER角色的扩容、迁移则较为复杂，通常要特别定义 | MASTER、SLAVE |
| frontendOperations | 数组，表示在角色的页面可对该角色执行哪些操作，候选操作包括"Start"、"Stop"、"Delete"、"Scaleout"、"Move"、"Commission"、"Decommission" | ["Start", "Stop", "Delete", "Scaleout"] |
| summaryPolicy | 在完成了角色的健康检查后，如何总结服务的健康状态。健康状态有HEALTHY、WARNING、DOWN。每个角色类型按照健康的角色数量确定该中角色类型的整体状态：所有角色都正常为HEALTHY；当有角色未正常时，summaryPolicy决定了一个阈值，当正常角色数量≥该阈值时为WARNING，否则为DOWN。若该类型角色的总数为N，ALL表示阈值为N，MAJOR表示阈值为N/2，SOME表示阈值为1，NONE表示阈值为0。服务的状态取所有角色类型状态最坏的一项。 | ALL、MAJOR、SOME、NONE |
| autoAssign | 创建服务时，自动为服务推荐角色的策略。为了扩展性，这是一个数组，每个元素有一个advice字段，例如：`!<EachNode> {}`表示在当前集群中所有未分配同类角色的节点上推荐该角色；也可指定默认推荐角色的数量，例如`!<NumSeq> {"numSeq": [5, 3, 1]}`表示依次以5个、3个、1个的数量尝试推荐不大于可用节点个数的角色 | |
| suggestion | 修改服务的角色时，当角色的數量不满足要求时，给出警告，但仍可能允许使用这个分配。这是一个数组，每个元素有个criteria字段，可组合不同的建议，例如，`!<Range> {"min": 2}`表示建议至少分配2个角色；`!<Range> {"min": 3, "oddity": true}`表示建议至少分配3个或以上的奇数个角色 | |
| validation | 修改服务的角色时，要求角色必须满足的要求。这是一个数组，每个元素有一个criteria字段，可组合不同的约束。例如，`!<Range> {"min": 1}`表示至少分配一个角色 | |
| deleteOpCondition | 删除服务的角色时，要求角色必须满足删除要求。这个要求有3种：deletable/movable/reject分别表示删除/迁移/拒绝删除需要满足的要求。每个要求中又有4类约束规则：number/decommission/minMaster/health分别表示数量/退役/最小master数量/健康状况，其中decommission目前用于datanode和nodemanager，minMaster/health用于es的检查，其他服务的角色的检查主要是number。 | zookeepe角色的检查条件,见“例1” |
| deleteOpCleanDirs | 删除服务角色时，需要清理的数据文件或目录。数据文件或目录的来源有2种，都是可选的:fromConfig/fromPath分别表示从配置项中解析/指定目录。每种来源都是一个数组，数组中每个元素又有两个必填字段：key和featureFile分别表示配置项/路径和特征文件(夹)。 特征文件(夹)用于校验要删除的目录是否符合要求。 | HDFS的datanode角色删除数据,见“例2” |

例1：zookeepe角色的检查条件，表示“zookeeper角色大于等于4个时才允许删除一个，有3个时需要迁移，有两个时拒绝删除”

`deleteOpCondition:
    deletable:
      number: 4
    movable:
      number: 3
    reject:
      number: 2`
      
例2：HDFS的datanode角色删除数据的配置

`deleteOpCleanDirs:
     fromConfig:
     - key: dfs.datanode.data.dir
       featureFile: in_use.lock
     fromPath:
     - key: /var/run/${service.sid}
       featureFile: dn_socket`

### 模板渲染与数据模型
目前服务标准化中所有的模板均通过Apache FreeMarker引擎渲染，模板的书写参考http://freemarker.org/docs/dgui.html
下面给出渲染模板使用的数据模型(data model)的结构。渲染模板时使用的数据模型，通常有两种上下文，即服务级别的和角色级别的，其主要区别是前者仅指定了当前服务，而后者指定了特定服务的特定角色，后者的数据模型中比前者多一些和特定角色特定节点相关的信息。
```
(root)
  |
  +- transwarpRepo # transwarp RPM repo的base URL
  +- service # 当前服务相关的信息
  |   +- id # 服务的id，正整数，自动生成，所有服务实例均不相同
  |   +- sid # 服务的后台标识符，字符串，自动生成，如inceptor1
  |   +- roles # 服务的角色
  |   |   +- INCEPTOR_METASTORE # 角色类型，这里举Inceptor Metastore为例子
  |   |   |   +- (1st)
  |   |   |   |   +- id # 角色的id，正整数，自动生成，所有角色实例均不相同
  |   |   |   |   +- hostname # 角色所在节点的hostname
  |   |   |   |   +- ip # 角色所在节点的IP
  |   |   |   ...
  |   |   ...
  |   +- node001 （主机名） # 以主机名为父hash，列出当前服务的node-specific的配置及值
  |   |   +- inceptor.metastore.memory = "4096" # hash的key为配置项的名称，值为该配置项在以父hash为主机名的节点的值，值的类型一定为字符串
  |   |   ...
  |   ...
  |   +- ngmr.fastdisk.size = "0.5" # 以配置的名称为key。isNodeSpecific为false的配置项在此处给出配置值；isNodeSpecific为true的配置项只有在指定角色级别的上下文后才会出现，给出该配置项在指定角色所在节点的配置值
  |   ...
  |   +- hive-site.xml（配置文件名） # 以configuration.yaml中指定的groups（配置文件名）的种类为父hash
  |   |   +- hive.metastore.warehouse.dir = "hdfs://nameservice1/inceptor1/user/hive/warehouse" # 配置项定义的groups字段含有父hash表示的配置文件名时，以配置的名称为key。isNodeSpecific为false的配置项在此处给出配置值；isNodeSpecific为true的配置项只有在指定角色级别的上下文后才会出现，给出该配置项在指定角色所在节点的配置值
  |   ...
  |   +- auth # 服务的认证方式，"simple"或"kerberos"
  |   +- realm # 启用安全时的realm，如"TDH"
  |   +- keytab # 启用安全时的keytab的路径，如"/etc/hdfs1/conf/hdfs.keytab"
  |   +- domain # 启用安全时的domain，如"dc=tdh"
  |   +- kdc
  |   |   +- hostname #启用安全时KDC的主机名
  |   |   +- port #启用安全时KDC的端口（如6088）
  |   +- plugins # 启用安全时的插件列表
  
```

### 配置项与配置推荐
配置项定义在configuration.yaml中，整个YAML是一个数组，每一个元素对应一个配置项，有如下字段：

| 字段 | 用途 |
|---|---|
| name | 配置项的名称 |
| recommendExpression | 配置项推荐表达式，FreeMarker模板，用于生成配置项的推荐值 |
| defaultValue | 当配置值与该值相同时，可不在生成配置文件时的data model中传入该配置项 |
| valueType | 用于验证配置值的合法性，可选类型包括：STRING, HOST, HOST_PORT, URI, ABSOLUTE_PATH, BOOL, NON_NEG_INT, PORT, BYTES, KB, MB, GB, MILLISECONDS, SECONDS, MINUTES, FLOAT, PERCENT |
| scope | 配置项的影响范围，有ServiceLevel和RoleTypes两种类型，例如，`!<ServiceLevel> {}`表示配置项影响整个服务，`!<RoleTypes> {roleTypes: [INCEPTOR_METASTORE]}`表示影响服务中所有INCEPTOR_METASTORE角色 |
| isNodeSpecific | true时，scope需为RoleTypes类型，其指定的角色类型所在的节点拥有不同的配置值，推荐值也分别计算；false时，该配置项一个服务只有一个值 |
| onDeps | 推荐配置计算需要的依赖服务列表，当该服务确定或修改列表中的依赖时，推荐值将重新计算。例如`['HDFS']`表示计算推荐值需要依赖的HDFS服务 |
| groups | 配置项直接出现的配置文件名（列表），详见“数据模型”节中的“配置文件名” |
| visibility | READ_WRITE：配置能够显示，admin权限的用户可以修改；PASSWORD：仅对admin权限的用户可见，在网页上显示为密码框；INDIRECT：可通过API获取，但是不在网页上显示；WRITE_ONLY：只能通过API修改，不能通过API获取；HIDDEN：不能通过API获取或修改 |

Manager会为服务的配置项计算推荐值，均在页面上显示，用户也可通过页面修改配置的值。这些条件下，推荐值会被计算或重新计算：
* ServiceLevel类型，或isNodeSpecific为false的配置项在服务创建时
* 指定了onDeps字段的配置项相应依赖发生变动时
* isNodeSpecific为true，RoleTypes类型的配置项，当对应类型的角色添加、重新分配时

推荐值计算的过程是模板渲染的过程，模板即recommendExpression字段的值。同一服务中配置项的推荐顺序是不确定的，因此同一服务中不同推荐值之间不应有互相依赖的假设。
数据模型主体为“数据模型”节服务级别上下文的模型，node specific的配置项还将合并附加信息：
```
(root)
 |
 +- localhostname #节点主机名
 +- rcmdMounts #节点上适用于作为数据目录父目录的挂载点列表，是一个字符串的数组，如`["/mnt/disk1", "/mnt/disk2"]`
 +- numCores #节点的CPU核心数
 +- memBytes #节点物理内存总大小
 +- disks #节点的磁盘（分区）列表
 |   +- (1st)
 |   |   +- fs # 物理设备名，如"/dev/sdb1"
 |   |   +- mountPoint # 挂载点，如"/mnt/disk1"
 |   |   +- size # 分区总容量（字节）
 |   ...
```

## 静态资源文件

### 服务的图标
服务的图标在application-metainfo的各服务各版本的resources/image目录中，需要提供4个图标，均为PNG格式，命名和作用如下：

| 图片名称 | 图片格式 | 图片作用 |
|---|---|---|
| icon-app.png | 48x48 彩色透明底 | 应用市场 |
| icon-default.png | 16x16 灰色（#616b77）透明底 | 菜单和Dashboard服务小图标 |
| icon-danger.png | 16x16 红色（#ec5353）透明底 | 菜单和Dashboard服务小图标的高亮状态 |
| icon-danger-medium.png | 42x42 红色（#ec5533）透明底 | 添加服务向导的服务图标 |

## 服务的部署与启动

### 操作
从页面触发相应操作时，Manager首先创建操作的执行计划，然后按计划执行操作，这些都能在“操作”页面查看。Manager中的操作是层次化定义和调度的，最大的分组单位为Job，每个Job中包含若干个依次执行的Stage，每个Stage中包含若干个依次执行的TaskGroup，每个TaskGroup包含若干个并行执行的Task。

#### Job的分解
最常使用的Job类型包括Init、Config、Start、Stop，分别为初始化服务、配置服务、启动服务、停止服务。
Job会分解成不同类型的Stage，可通过metainfo.yaml中的jobs字段指定，若不指定，则使用默认的分解规则。例如，HDFS的metainfos里定义了如下jobs字段：
```yaml
jobs:
  - type: Stop
    stages:
    - Checkpoint
    - Stop
```
表示HDFS的Stop类型的Job会被分解成一个Checkpoint类型的Stage和一个Stop类型的Stage，其余类型的Job按照默认方式分解。
常见类型的Job的默认分解规则如下：

| Job类型 | 默认分解Stages规则 |
|---|---|
| Init | 若定义了Bootstrap类型的Stage，则分解为Install, Config, Bootstrap, Start，否则分解为Install, Config, Start |
| Config | Config |
| Start | Start |
| Stop | Stop |
| Scaleout | Install, Config, Scaleout |
| MoveRole | Install, Config, MoveRole |

#### Stage的分解
Stage会分解成不同类型的TaskGroup，可通过metainfo.yaml中的stages字段指定，若不指定，则按默认规则分解。例如，Inceptor的metainfo里指定了Stages字段：
```yaml
stages:
  - type: Config
    taskGroups:
    - !<Create-Database>
      dbPrefix: metastore
      dbUserConfig: javax.jdo.option.ConnectionUserName
      dbPasswordConfig: javax.jdo.option.ConnectionPassword
      timeoutMinutes: 5
      summaryPolicy: SOME
    - !<Role>
      roleType: "INCEPTOR_METASTORE"
      operation: Config
      summaryPolicy: SOME
      timeoutMinutes: 1
    - !<Role>
      roleType: "INCEPTOR_SERVER"
      operation: Config
      summaryPolicy: SOME
      timeoutMinutes: 1
    - !<Role>
      roleType: "INCEPTOR_EXECUTOR"
      operation: Config
      summaryPolicy: SOME
      timeoutMinutes: 1
```
表示Inceptor的Config步骤将被分解成一个创建metastore数据库的TaskGroup，和配置Metastore、Server、Executor角色的3个TaskGroup。其余类型的Stage按默认规则分解。

常见类型的Stage分解默认分解规则如下：

| Stage类型 | 默认分解为TaskGroups的规则 |
|---|---|
| Install | 按角色类型出现的顺序，分解为多个Role(operation=Install) |
| Config | 按角色类型出现的顺序，分解为多个Role(operation=Config) |
| Start | 先按角色类型出现的顺序，分解为多个Kubectl-Label(action=AddLabel)，然后按角色类型出现的顺序，分解为多个Kubectl(action=Start) |
| Stop | 先按角色类型出现**相反**的顺序，分解为多个Kubectl-Label(action=RemoveLabel)，然后按角色类型出现**相反**的顺序，分解为多个Kubectl(action=Stop) |
| Scaleout | 先按角色类型出现的顺序，分解为多个Kubectl-Label(action=AddLabel)，然后按角色类型出现的顺序，分解为多个Kubectl(action=Scaleout) |
| MoveRole | 先按角色类型出现的顺序，分解为多个Kubectl-Label(action=AddLabel)，然后按角色类型出现的顺序，分解为多个Kubectl(action=MoveRole) |
| PreDeleteAfterStop | 按角色类型出现的顺序，分解为多个DockerRunPreDelete |

#### TaskGroup的分解
TaskGroup最终按类型和参数分解为多个并行的Task。在metainfo.yaml中用`!<类型>`区分TaskGroup的类型，所有TaskGroup都有这些字段：
* summaryPolicy 在TaskGroup中的所有Task执行后，如何总结TaskGroup的结果。按照成功的Task数量确定该TaskGroup的整体状态：所有Task都成功为SUCCESSFUL；当有Task未成功时，summaryPolicy决定了一个阈值，当成功Task数量≥该阈值时为WARNING，否则为FAILED。若该类型角色的总数为N，ALL表示阈值为N，MAJOR表示阈值为N/2，SOME表示阈值为1，NONE表示阈值为0。
                当某一TaskGroup为FAILED时，后继的TaskGroup将不再继续执行，Stage进入FAILED状态；当某一TaskGroup为WARNING时，后继的TaskGroup将继续执行，所有可执行的TaskGroup执行完成并状态至少为WARNING后，Stage进入WARNING状态，可重试或跳过Stage
* timeoutMinutes TaskGroup分解为Task后，各Task的最长允许执行时间
 
目前可选的常用TaskGroup包括：
* Role
  将根据roleType字段指定类型的角色，分解成多个Role Task，在“Role Task执行的实际操作”一节将详细介绍。参数字段包含：
  * summaryPolicy
  * timeoutMinutes
  * roleType 操作作用的角色类型，将根据该类型的角色分解Task
  * operation 分解为Task执行的操作，常见的操作有Install、Config、Start、Stop
* Kubectl-label
  将根据roleType字段指定类型的角色，分解成多个Kubectl-label Task。Label用于帮助Kubernetes调度，确定在哪些节点上创建Pod。
  参数字段包含：
  * summaryPolicy
  * timeoutMinutes
  * roleType 操作作用的角色类型，将根据该类型的角色分解Task
  * action AddLabel或RemoveLabel
  * labelPrefix label的前缀
  * labelValue label的值
* Kubectl
  分解为一个Task，执行相应的kubectl命令。其中Start类型的操作在“启动服务”节详细阐述。Kubectl TaskGroup包含一下参数字段：
  * summaryPolicy
  * timeoutMinutes
  * action 实际执行的kubectl操作，目前支持Start, Stop, Scaleout, MoveRole, StartRole, StopRole
  * file 传给kubectl命令的YAML文件名
* Create-Dir-in-HDFS
  分解为一个Task，在依赖的HDFS中创建目录，参数字段包括：
  * summaryPolicy
  * timeoutMinutes
  * dirs 创建的目录列表（数组），每个元素是FreeMarker模板，数据模型为服务级别，如YARN指定了`["/${service.sid}/user" , "/${service.sid}/user/history", "/${service.sid}/var/log/hadoop-yarn/apps"]`
  * user 创建目录的所属用户
  * group 创建目录的所属组
  * mod 创建目录的权限
* Create-Database
  分解为一个Task，在依赖的TxSQL中创建数据库，参数字段包括：
  * summaryPolicy
  * timeoutMinutes
  * dbPrefix 数据库名称前缀
  * dbUserConfig 设定数据库用户的配置项
  * dbPasswordConfig 设定数据库密码的配置项
* Create-Database-in-Inceptor
  分解为一个Task，在依赖的Inceptor中创建数据库，参数字段包括：
  * summaryPolicy
  * timeoutMinutes
  * dbNames 创建的数据库的列表，如TDT服务指定了`["tdt", "tdt_results"]`
* Wait-Healthy
  只产生一个Task，该Task等待整个服务进入HEALTHY状态
* DockerRunPreDelete
  将根据roleType字段指定类型的角色，分解成多个Docker Run Task。
  参数字段包含：
  * summaryPolicy
  * timeoutMinutes
  * roleType 操作作用的角色类型，将根据该类型的角色分解Task
  * node 操作作用的节点的选择方式，Any表示任意一个节点上执行，Each表示所有节点上执行

#### Role Task执行的实际操作
前面已经介绍过，在metainfo.yaml的roles字段指定了不同类型的角色。
每个类型的角色有一个operations字段，内容为一个数组，指定了该类Role不同的Role Task实际执行的操作。每个元素有以下字段：
* type 操作的类型。Role TaskGroup的operation字段转换为该字段。
* directives RoleTask包含操作的列表，列表的每个元素是一个小操作，每个元素包含下列字段：
  * necessary 如果该操作失败，整个Task是否失败。可选，缺省为true。
  * hideCmdByDesc 可选，字符串。如果指定该字段，则用字段内容覆盖日志中显示的命令。用于在日志中隐藏一些敏感信息如密码。
  * hideOut 是否在操作日志中隐藏命令的OUT输出，用于在日志中隐藏一些敏感信息如密码。可选，缺省为false。
  * hideErr 是否在操作日志中隐藏命令的ERR输出，用于在日志中隐藏一些敏感信息如密码。可选，缺省为false。
  * directive 具体执行的小操作，用`!<类型>`指定类型。
              每一个小操作实际包含一些Manager端执行的操作和在Role所在节点执行的操作，整个Role Task先依次执行Manager端操作，再依次执行Role所在节点操作。例如，某个Role Task里有A、B两个directive，其中A的Manager端操作为A1，Role所在节点操作为A2，B的Manager端操作为B1，Role所在节点的操作为B2，则执行顺序依次为A1,B1,A2,B2。
    目前directive支持如下类型：
    * resource
        以templates目录中的资源作为源文件或模板，在角色所在节点上生成资源文件
        * templateType Raw表示直接复制到目标目录；FreeMarker表示以源文件为模板，以角色上下文渲染生成目标文件，最终复制到目标目录
        * templatePath templates目录中源文件的文件名
        * targetPath 目标主机上目标文件的路径模板，以角色上下文渲染实际路径
        * mode 目标文件的权限数字表示如"755"、"600"，当最后一位为0时，在Manager页面上导出客户端、配置文件时将不导出该文件。
    * shell
        在角色所在节点上直接执行shell命令
        * script 命令的模板，以角色上下文渲染实际命令
    * mkdirs
        在角色所在节点上创建目录
        * paths 数组，每个元素是目录路径的模板，以角色上下文渲染实际路径
        * mode 目标目录的权限数字表示如"755"、"600"
    * download
        从指定URL，下载文件到角色所在节点上
        * url 源URL模板，以角色上下文渲染
        * targetPath 目标文件的路径模板，以角色上下文渲染实际路径
    * chmod
        在角色所在节点上修改文件权限
        * path 路径模板，以角色上下文渲染实际路径
        * mode 目标文件的权限数字表示如"755"、"600"
    * systemctl
        在角色所在节点上通过systemctl启停服务
        * action EnableStart表示依次执行enable和start启用服务；DisableStop表示依次执行disable和stop停用服务
        * service 服务名称模板，以角色上下文渲染实际服务的名称
        * sleepSec 启动/停止服务后，等待指定时间，再使用systemctl status确认启动/停止的结果
    * link
        在角色所在节点上建立/断开软链接
        * action Link表示建立软连接；Unlink表示断开软连接
        * from 源文件的路径模板，以角色上下文渲染实际路径
        * to 软连接的路径模板，以角色上下文渲染实际路径

type为Config的Role Task，在metainfo.yaml中指定的操作之前，还会自动执行一些操作，详见“配置文件的渲染”节。

### 配置文件的渲染
type为Config的Role Task，会隐含地根据templates目录中特定后缀的文件生成若干个resource类型directive：以后缀决定模板的类型（templateType），目标路径为`/etc/${service.sid}/conf/${去掉后缀的文件名}`，权限为755。
所有后缀以.raw结尾的源文件将对应生成templateType为Raw的directive，以.ftl结尾的模板文件将对应生成templateType为FreeMarker的directive。
例如，假设HDFS的templates目录下有hdfs-site.xml.ftl和log4j.properties.raw两个文件，集群中有一个HDFS1实例（sid为hdfs1），则其Config Role Task的最开头会隐含地产生这样两个directive：

```yaml
directives:
- directive: !<resource>
    templateType: FreeMarker
    templatePath: "hdfs-site.xml.ftl"
    targetPath: "/etc/hdfs1/hdfs-site.xml"
    mode: "755"
- directive: !<resource>
    templateType: Raw
    templatePath: "log4j.properties.raw"
    targetPath: "/etc/hdfs1/log4j.properties"
    mode: "755"
```

请不要用.ftl结尾的模板生成含有敏感信息（如密码）的配置文件，建议使用resource型的directive手动指定敏感配置文件的渲染，并指定类似600的严格权限。Manager页面上的导出配置文件功能不会导出没有OTHERS_READ权限的文件。

### 启动服务
Start类型的Kubectl Task，启动服务的过程，先做一些准备如准备挂载点，然后生成Deployment的YAML（位于Manager节点的`/var/lib/transwarp-manager/master/content/resources/services`下），最后执行kubectl create命令触发Deployment的启动。
最终Kubernetes在预先分配的角色节点上启动Docker容器

#### 容器特性
* 使用host network，即Pod或容器均没有独立的虚拟网卡和IP地址，使用和主机完全相同的网络
* 允许执行特权指令，如umount

#### 镜像名称
可通过metainfo.yaml的dockerImage字段指定服务级别的image路径，也可通过roles字段对应角色的dockerImage字段为某个角色指定image路径。
例如，HDFS的服务级别的dockerImage指定了`dockerImage: "transwarp/hdfs:tdh500"`，在角色级别，HTTPFS角色又指定了`dockerImage: "transwarp/httpfs:tdh500"`，假如集群本地Registry的地址为`node1:5000`，则启动HTTPFS角色拉取的镜像为`node1:5000/transwarp/httpfs:tdh500`，启动HDFS其余角色拉取的镜像为`node1:5000/transwarp/hdfs:tdh500`

#### 启动命令
启动容器使用的启动命令为`boot.sh ${roleType}`，其中`${roleType}`为角色的标识符，例如启动Inceptor Metastore，启动命令为`boot.sh INCEPTOR_METASTORE`。

#### 环境变量
启动容器带入的环境变量在metainfo.yaml中，roles字段相应的角色的env字段指定，为一个数组，每一个元素由字段`name`指定环境变量的名称，`value`为一个模板，将以服务级别的上下文渲染。
例如，HDFS的DataNode需要传入`HADOOP_CONF_DIR`这个环境变量，则在roles的DataNode元素的env字段指定了如下内容：
```yaml
env:
- name: HADOOP_CONF_DIR
  value: /etc/${service.sid}/conf
```

#### 挂载卷
容器的挂载卷由这几部分组成：

* 缺省挂载卷
    
    | 主机路径 | 容器路径 | 用途 |
    |---|---|---|
    | `/transwarp/mounts/${service.sid}` | /vdir | 见“角色/节点级别自定义挂载卷”节 |
    | /usr/lib/transwarp/plugins | /usr/lib/transwarp/plugins | 安全插件 |
    | /etc/localtime | /etc/localtime | 保持容器时区与主机一致 |
    | /etc/transwarp/conf | /etc/transwarp/conf | hosts, 机柜等节点级别配置 |
    | `/etc/${依赖服务的sid}/conf` | `/etc/${依赖服务的sid}/conf` | 当前服务依赖及传递依赖的所有服务的配置目录 |

    为了保证容器内域名/etc/hosts与主机一致，容器的启动脚本/bin/boot.sh需要包含以下内容：
    ```bash
    echo 'umount /etc/hosts'
    umount /etc/hosts
    echo 'rm -rf /etc/hosts'
    rm -rf /etc/hosts
    echo 'ln -sf /etc/transwarp/conf/hosts /etc/'
    ln -s /etc/transwarp/conf/hosts /etc/
    ```

* 角色类型级别自定义挂载卷
    metainfo.yaml的每种角色的mountPaths属性指定了角色的自定义挂载卷，该属性为一个数组，每个元素包含3个字段:
    
    | 字段 | 用途 |
    |---|---|
    | type | |Manager 6.0 1811b 新增: 支持挂载 nfs 和 pvc, 新增字段 type 来识别三种挂载|
             |type = HOST_PATH_CONF || NFS_CONF || PVC_CONF, 分别代表三种不同的挂载 hostPath, nfs, persistentVolumeClaim|
             |没有 type 字段 默认为 HOST_PATH_CONF　类型, 如需特殊挂载路径, 需要声明 type|  
    | mountPath | 容器挂载点路径的模板（服务级别上下文）|
    | hostPath || nfs || persistentVolumeClaim | 主机路径的模板（服务级别上下文）|
    | name | 挂载卷的标识符，由小写字母组成，同一服务中不应重复 |
    
    例如，HDFS的DataNode需要挂载主机上的`/var/run/${service.sid}`到容器中的`/var/run/${service.sid}`，其在DataNode角色的mountPaths字段里指定了：
    ```yaml
     mountPaths:
     - mountPath: /var/run/${service.sid}
       hostPath: /var/run/${service.sid}
       name: hdfssocketdir
    ```
    例如，SOPHON 的 SOPHON_WEB 需要挂载网络文件系统(nfs)到容器中的` /sophon/project`，其在 SOPHON_WEB 角色的 mountPaths 字段里指定了：
    ```yaml
    mountPaths:
    - type: NFS_CONF
      mountPath: /sophon/project
      nfs:
        server: ${service['sophon.nfs.ip']}
        path: "/"
      name: nfs
    ```    

* 角色/节点级别自定义挂载卷

    一些角色需要存储大量的数据，通常希望角色的数据目录存放在主机的外挂磁盘上，并且物理主机可能有多个外挂盘，不同的节点外挂盘可能不同，因此需要为每个节点配置不同的值。这样的数据目录需要按以下步骤配置：
    <ol>
    <li> 在configuration.yaml中声明该配置项，scope为RoleTypes类型并指定相关角色，isNodeSpecific为true </li>
    <li> 在metainfo.yaml的相关角色的nodeSpecificMounts字段指定该配置项，例如HDFS的Data Node的配置dfs.datanode.data.dir，在HDFS的metainfo.yaml的Data Node角色的nodeSpecificMounts字段中指定了：
    <pre>
    <code>nodeSpecificMounts:
        - configKey: dfs.datanode.data.dir
    </code>
    </pre>
    </li>
    <li> Manager在部署服务时，会读取nodeSpecificMounts指定配置项在相应节点的值，以英文逗号分隔，将当前节点主机目录$dir挂载（mount --bind）到/transwarp/mounts/${service.sid}$dir
         例如，假如dfs.datanode.data.dir在node1上的值为"/mnt/disk1/hadoop/data,/mnt/disk2/hadoop/data"，则Manager在node1上会执行以下挂载：
    <pre>
    <code>mkdir -p /transwarp/mounts/mnt/disk1/hadoop/data && mount --bind /mnt/disk1/hadoop/data /transwarp/mounts/mnt/disk1/hadoop/data
    mkdir -p /transwarp/mounts/mnt/disk2/hadoop/data && mount --bind /mnt/disk2/hadoop/data /transwarp/mounts/mnt/disk2/hadoop/data
    </code>
    </pre>
    </li>
    <li> 书写配置文件模板，使Manager在生成配置文件时写入该配置项的值。nodeSpecificMounts中的配置项值在数据模型中自动会在每个逗号分隔的片段中前置/vdir前缀，书写模板时不要再画蛇添足添加该前缀。 </li>
    <li> 启动容器时，主机的/transwarp/mounts将被挂载到容器的/vdir目录，因此容器中最终可通过/vdir/$dir访问到对应主机上的$dir目录。实际上，通过读取上一步渲染的配置文件，角色进程取到的就是容器中数据目录的路径，无需额外处理。 </li>
    </ol>

#### 资源限制与保留额度
  通过metainfo.yaml中resources角色各自的resources字段指定资源限制使用的配置项，该字段为对象，有下列字段：

| 字段 | 用途 |
|---|---|
| limitsMemoryKey | 通过哪一个配置项指定容器的内存限制，该配置项值为-1时表示无限制，值为正整数时表示限制容器的内存，单位为GB |
| limitsCpuKey | 通过哪一个配置项指定容器的CPU虚核数限制，该配置项值为-1时表示无限制，值为正整数时表示限制容器的CPU |
| requestsMemoryKey | 通过哪一个配置项指定容器的内存最小保留额度，该配置项值为-1时表示无最小保留额度，值为正整数时表示容器的内存保留额度，单位为GB |
| requestsCpuKey | 通过哪一个配置项指定容器的CPU虚核数最小保留额度，该配置项值为-1时表示无最小保留额度，值为正整数时表示容器的CPU保留额度 |

### 升级信息
  服务的升级信息在upgrade文件夹中，每个文件给出了最近的一个可升级到当前版本升级到当前版本的升级过程定义

```yaml
---
upgrade:
  fromVersion: "5.0"
  rolling: true
```

## 调试方法
前面讲述了TDH 5.0中Manager部署和启动服务的模型，有时服务的开发者需要修改服务的一些特性，并进行快速验证。本章分别介绍需要修改服务元信息和修改服务镜像两种情况下在集群上调试的一般方法。
### 修改服务元信息后快速验证
修改元信息，包括修改服务的定义metainfo.yaml、修改配置定义和推荐值configuration.yaml、修改配置文件的模板等，一般过程如下：
1. 修改元信息，即Manager节点的`/var/lib/transwarp-manager/master/content/meta/services/`下对应服务对应版本的元信息
2. 重启Transwarp Manager，使Manager能重新加载服务元信息
3. 执行验证操作，通常：
  * 修改了metainfo.yaml中服务定义相关信息，需要创建新的服务来验证修改
  * 修改了configuration.yaml中服务配置项的推荐值，需要触发相应配置项的重新推荐来验证修改。最简单的方法是创建新的服务，在选择完配置后不需要安装服务，直接从新窗口进入Manager主界面，点入刚创建的服务的配置页面查看推荐值的计算情况。如果推荐值没有生成，可查看Manager节点的`/var/log/transwarp-manager/master/transwarp-manager.log`，搜索`failed to recommend config`关键字。此外在以下情况下配置的推荐值也会重新计算：
    * scope为ServiceLevel类型，或isNodeSpecific为false的配置项，在创建新服务时计算推荐值
    * scope为ServiceLevel类型，且推荐值计算需要依赖服务的信息（onDeps不为空），在创建新服务时自动推荐依赖、通过向导中的选项修改依赖，或安装完成后通过“更新依赖”功能修改依赖时重新计算
    * scope为RoleTypes类型，且isNodeSpecific为true的配置项，在创建新服务时自动推荐角色、通过向导中的选项修改角色分配，或在安装完成后添加相关角色、迁移相关角色时会重新计算
  * 修改了templates目录中的配置文件模板，需要通过“配置服务”功能生成新的配置文件来验证修改

### 修改服务镜像后快速验证
修改服务镜像后，通常需要执行以下步骤进行验证：

1. 确定本地Registry的主机名/IP和端口，Registry位于Manager节点，端口为Registry服务的registry.port配置项，默认为5000。我们需要为新修改的服务镜像打一个tag，例如，我们修改了Inceptor的image，修改后的镜像为c96302b6269a，Registry Server为node123:5000，调试时我们需要给测试image一个临时的版本如`tdh500.123`，则执行
```bash
docker tag c96302b6269a node123:5000/transwarp/inceptor:tdh500.123
```
2. push新的image到本地Registry，例如上述例子中，我们执行：
```bash
docker push node123:5000/transwarp/inceptor:tdh500.123
```
3. 修改服务元信息中image的名称，需要修改metainfo.yaml：如果是服务级别共享的image，修改顶层的dockerImage字段，如上述例子中需要将dockerImage字段的值修改为`transwarp/inceptor:tdh500.123`；如果是角色级别的image，则需要修改相应角色的dockerImage字段
4. 重启Manager，使Manager重新加载上述dockerImage信息
5. 从Manager的界面重启需要验证的服务或角色
