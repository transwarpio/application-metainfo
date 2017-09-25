## 仓库结构

版本管理通过以下两个仓库进行，为镜像关系

http://172.16.1.41:10080/managability/application-metainfo（以下称“内部仓库”）

https://github.com/transwarpio/application-metainfo（以下称“公开仓库”）

每个仓库有dev和master两个branch

目录布局，第一层是各个服务类型的目录，第二层是服务的版本，服务在历史上发布过的所有版本都将有相应的目录，示例如下：

```
+  RUBIK
|   + transwarp-5.0.0-rc5
|   + transwarp-5.0.0-rc6
|   + transwarp-5.0.0-final
|   + transwarp-ce-1.0
|   + transwarp-5.1
+  INCEPTOR
|   + transwarp-5.0.0-rc5
|   + transwarp-5.0.0-rc6
|   + transwarp-5.0.0-final
|   + transwarp-ce-1.0
|   + transwarp-5.1
```

## 开发流程

从内部仓库的dev分支拉出个人的分支进行开发修改，修改完成后向内部仓库的dev分支发起merge request。

dev分支中较短版本号的版本目录（如transwarp-5.1，transwarp-ce-1.0）表示正在开发的版本的元信息，较长版本号的版本目录（如transwarp-5.1.0-rc1，transwarp-ce-1.0.1）表示即将或已经发布的版本，开发过程只修改未发布版本的元信息。

元信息与模板的开发标准参见 [服务标准化手册](/TDH 5.0 service standard.md)

## 打包流程

当需要发布一个版本（包括RC和正式版本）时，需要在dev分支中建立具体对应版本的目录（如transwarp-5.1.0-rc1），内容来自开发版本，并且注意需要以下修改：

检查该服务版本和Manager、Guardian版本的关系（约束），并通过modelVersion文件进行约束

检查是否需要将已有版本升级到当前版本，并在upgrade文件夹中进行指定。通常不能将已有版本直接升级到RC版本，社区版可以升级到对应的商业版（如transwarp-ce-1.0.0到transwarp-5.1），商业版可以向上升级

需要将UTF-8编码的中英文Release Notes同时放在resources/features_zh_CN.txt和resources/features_en_US.txt

在打TDH-Basic包时，将对应版本的metainfo文件夹进行抽取，放到TDH-Basic包的service_meta目录下，例如我们要发布transwarp-5.0.0-final版本，那么在TDH-Basic包中metainfo的布局如下：

```
transwarp
+  service_meta
|   +  RUBIK
|   |   + transwarp-5.0.0-final
|   +  INCEPTOR
|       + transwarp-5.0.0-final
```

注意：不要将.git或.svn信息带入service_meta目录。参考抽取脚本：

```bash
# 假设$META_SRC_DIR为从内部仓库上checkout出的dev branch的目录，$META_DST_DIR为TDH-Basic包的service_meta目录，$VERSION是正在打包的版本（如"transwarp-5.0.0-final"）
 
cd "$META_SRC_DIR"
dirs=()
while IFS=  read -r -d $'\0'; do
  dirs+=("$REPLY")
done < <(find . -name "$VERSION" -print0)
if [ -d "$META_DST_DIR" ]; then
  rm -rf "$META_DST_DIR"
fi
mkdir -p "$META_DST_DIR"
for dir in "${dirs[@]}"; do
  mkdir -p "$META_DST_DIR/$dir"
  cp -rp $dir/* "$META_DST_DIR/$dir/"
done
```

## 公开发布流程

公开发布意味客户已经安装的TDH中，Manager界面的应用市场上将出现该新版本，客户可以通过在线升级安装或者升级到该版本。

在正式版本（不包括RC版本）正式交付过程必须严格安装以下步骤顺序发生

1. 确保腾讯云上的Harbor已经包含了该版本需要的所有image

1. 将dev branch上相关版本的目录都merge到master分支，并推送到github上 （如果没有步骤1而做了该步骤，在Manager的应用市场会出现一个无法安装或升级的版本）

1. 通过官方邮件发布，使实施人员能够在客户集群中安装
