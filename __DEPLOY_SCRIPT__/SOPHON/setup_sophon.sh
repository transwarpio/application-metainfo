#!/usr/bin/env bash

# trap “echo Fail unexpectedly on line \$FILENAME:\$LINENO!” ERR 

currentpath=$(cd `dirname $0`; pwd)
basepath=${currentpath}/../
imagespath=${basepath}/images
metainfopath=${basepath}/service_meta

version=`${currentpath}/jq -r '.manifests[].annotations."org.opencontainers.image.ref.name"' ${imagespath}/index.json |grep sophon-web-ui|cut -d':' -f2`

# registry_addr=$(grep `hostname` /etc/hosts|awk  '{print $1}'):5000
registry_addr=$(hostname -i):5000


# upload sophon images
for image in `${currentpath}/jq -r '.manifests[].annotations."org.opencontainers.image.ref.name"' ${imagespath}/index.json |grep sophon`; 
do  
   echo "COPY Image: "${image}
   ${currentpath}/skopeo  --insecure-policy=true copy --dest-tls-verify=false oci:${imagespath}:${image} docker://${registry_addr}/${image}  1>setup_log.txt ;
done

# upload sophon metainfo
echo "COPY SOPHON META"
\cp -rf 52 /var/lib/transwarp-manager/master/content/meta/services/SOPHON/


# upload kong images
for image in `${currentpath}/jq -r '.manifests[].annotations."org.opencontainers.image.ref.name"' ${imagespath}/index.json |grep kong`;
do
   echo "COPY Image: "${image}
   ${currentpath}/skopeo --insecure-policy=true copy --dest-tls-verify=false oci:${imagespath}:${image} docker://${registry_addr}/${image}  1>setup_log.txt  ;
done


# upload stellardb images
for image in `${currentpath}/jq -r '.manifests[].annotations."org.opencontainers.image.ref.name"' ${imagespath}/index.json |grep stellardb`;
do
   echo "COPY Image: "${image}
   ${currentpath}/skopeo --insecure-policy=true copy --dest-tls-verify=false oci:${imagespath}:${image} docker://${registry_addr}/${image}  1>setup_log.txt  ;
done


# upload kong metainfo
echo "COPY KONG META"
\cp -rf ${metainfopath}/KONG/* /var/lib/transwarp-manager/master/content/meta/services/KONG/

echo "COPY STELLARDB META"
\cp -rf ${metainfopath}/STELLARDB/* /var/lib/transwarp-manager/master/content/meta/services/KONG/

# upload hdfs plugins
echo "COPY HDFS PLUGIN"
\cp -f ${basepath}/plugin/sophon-hdfs-0.12.0+500.1.tar.gz /var/lib/transwarp-manager/master/content/meta/plugins/

# restart manager
echo "Restart Manager ..."
/etc/init.d/transwarp-manager restart
