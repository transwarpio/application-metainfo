import os, re, sys, shutil
import json, yaml

def replaceMetainfoWithLatestVersion():
  print 'Replace service metainfo with latest version ...'
  for service in os.listdir('../'):
    servicePath = '../{:s}'.format(service)
    if not os.path.isdir(servicePath):
      continue

    versions = os.listdir(servicePath)
    for version in versions:
      metaDir = os.path.join(servicePath, version)
      if not os.path.isdir(metaDir):
        continue

      list = version.split('-')
      # final version or non-release version, just skip
      if not list[-1].startswith('rc'):
        continue

      rcVersion = list.pop()
      versionPrefix = '-'.join(list)

      #find the latest version
      latestVersion = version
      finalVersion = versionPrefix + '-final'
      finalDir = os.path.join(servicePath, finalVersion)
      if os.path.exists(finalDir):
        latestVersion = finalVersion
      else:
        for curVersion in versions:
          if not curVersion.startswith(versionPrefix + '-'):
            continue
          latestNum = latestVersion.replace(versionPrefix + '-rc', '')
          curNum = curVersion.replace(versionPrefix + '-rc', '')
          if int(curNum) > int(latestNum):
            latestVersion = curVersion

      # need replace metainfo only if latest version is different from current version
      if latestVersion != version:
        # start replace metainfo with latest version
        print 'Replace %s %s with %s ...' % (service, version, latestVersion)
        shutil.rmtree(metaDir)
        latestDir = os.path.join(servicePath, latestVersion)
        shutil.copytree(latestDir, metaDir)

        for (path, dirs, files) in os.walk(metaDir):
          for file in files:
            filePath = os.path.join(path, file)
            f = open(filePath, 'r')
            filedata = f.read()
            f.close()

            filedata = re.sub(latestVersion, version, filedata, flags=re.M)

            f = open(filePath, 'w')
            f.write(filedata)
            f.close()
  print 'Replace service metainfo with final version finished.'

def replaceVersionTags(tags):
  print 'Replace service version and images tags ...'
  for (path, dirs, files) in os.walk('../', topdown=False):
    if('__' in path):
      continue
    if('resources' in path):
      continue
    if('i18n' in path):
      continue
    if(r'.git' in path):
      continue

    for file in files:
      f = open(os.path.join(path, file),'r')
      filedata = f.read()
      f.close()

      filename = file
      for tag in tags:
        #replace image tags
        pattern = r':{:s}-(?!manager)'.format(tag['original'])
        repl = r':{:s}-'.format(tag['replacement'])
        filedata = re.sub(pattern, repl, filedata, flags=re.M)

        #replace meta versions
        pattern = r':\s+{:s}-(?!manager)'.format(tag['original'])
        repl = r': {:s}-'.format(tag['replacement'])
        filedata = re.sub(pattern, repl, filedata, flags=re.M)

        #replace release date
        pattern = r',{:s}-(?!manager)'.format(tag['original'])
        repl = r',{:s}-'.format(tag['replacement'])
        filedata = re.sub(pattern, repl, filedata, flags=re.M)

        #replace upgrade path filename
        if(tag['original'] in file):
          filename = re.sub(tag['original'], tag['replacement'], filename)

      if(file != filename):
        #print '%s rename file as %s' % (file, filename)
        os.rename(os.path.join(path, file), os.path.join(path, filename))
      f = open(os.path.join(path, filename),'w')
      f.write(filedata)
      f.close()

    #replace metainfo directory name
    for dir in dirs:
      dirname = dir
      for tag in tags:
        dirname = re.sub(tag['original'], tag['replacement'], dirname)
      if(dir != dirname):
        #print '%s rename dir as %s' % (dir, dirname)
        shutil.move(os.path.join(path, dir), os.path.join(path, dirname))
  print 'Replace service version and images tags finished.'

def replaceReservedTagsAndDeleteOthers(tags):
  print 'Replace metainfo for reserved versions and delete other versions ...'
  #replace metainfo version directory name and delete un-reserved ones
  for service in os.listdir('../'):
    if('__' in service):
      continue
    if(r'.git' in service):
      continue

    path = '../{:s}'.format(service)
    if not os.path.isdir(path):
      continue
    for dir in os.listdir(path):
      dirname = dir
      for tag in tags:
        dirname = re.sub(tag['original'], tag['replacement'], dirname)
      if(dir != dirname):
        # print '%s rename dir as %s' % (dir, dirname)
        shutil.move(os.path.join(path, dir), os.path.join(path, dirname))
      else:
        shutil.rmtree(os.path.join(path, dir))
        print 'Deleted %s' % os.path.join(path, dir)

  for (path, dirs, files) in os.walk('../', topdown=False):
    if('__' in path):
      continue
    if('resources' in path):
      continue
    if('i18n' in path):
      continue
    if(r'.git' in path):
      continue

    for file in files:
      f = open(os.path.join(path, file),'r')
      filedata = f.read()
      f.close()

      filename = file
      for tag in tags:
        #replace versions and tags in files
        pattern = tag['original']
        repl = tag['replacement']
        filedata = re.sub(pattern, repl, filedata, flags=re.M)

        #replace upgrade path filename
        if(tag['original'] in file):
          filename = re.sub(tag['original'], tag['replacement'], filename)

       # upgrade path should be deleted if not in reserve tags
      if path.endswith('/upgrade') and file == filename:
        os.remove(os.path.join(path, file))
        print 'Deleted upgrade path %s' % os.path.join(path, file)
        continue

      if(file != filename):
        os.rename(os.path.join(path, file), os.path.join(path, filename))
      f = open(os.path.join(path, filename),'w')
      f.write(filedata)
      f.close()

  print 'Replace metainfo for reserved versions and delete other versions finished.'

def replaceProductsInfo(products):
  print 'Replace metainfo for products ...'
  for product in products:
    name = product['name']
    print 'Replace metainfo for %s ...' % name
    for file in product['i18n']:
      filename = '../__PRODUCT_INF__/{:s}/i18n/{:s}'.format(name, file)
      f = open(filename,'r')
      filedata = f.read()
      f.close()
      for entry in product['i18n'][file]:
        for key in entry:
          value = entry[key]
          pattern = r'^{:s}=.+$'.format(key)
          repl = '{:s}={:s}'.format(key, json.dumps(value).replace('"', ''))
          filedata = re.sub(pattern, repl, filedata, flags=re.M)

      f = open(filename,'w')
      f.write(filedata)
      f.close()
  print 'Replace metainfo for products finished.'

def copy_tree(srcDir, dstDir, overwrite=False):
  if not os.path.exists(dstDir):
    os.makedirs(dstDir)

  for file in os.listdir(srcDir):
    srcFile = os.path.join(srcDir, file)
    dstFile = os.path.join(dstDir, file)

    if os.path.isfile(srcFile):
      if overwrite or not os.path.exists(dstFile):
        open(dstFile, "wb").write(open(srcFile, "rb").read())

    if os.path.isdir(srcFile):
      copy_tree(srcFile, dstFile, overwrite)

def replaceServiceResources(baseDir):
  print 'Replace service resources...'
  for service in os.listdir(baseDir):
    if('__' in service):
      continue

    srcDir = os.path.join(baseDir, service)
    if not os.path.isdir(srcDir):
      continue

    servicePath = '../{:s}'.format(service)
    if os.path.exists(servicePath):
      versions = os.listdir(servicePath)
      for version in versions:
        dstDir = os.path.join(servicePath, version)
        if not os.path.isdir(dstDir):
          continue
        print 'Replace service resources from %s to %s' % (srcDir, dstDir)
        copy_tree(srcDir, dstDir, overwrite=True)
  print 'Replace service resources finished.'

def deleteServicesMeta(services):
  print 'Delete metainfo for services ...'
  for service in services:
    print 'Delete metainfo for service %s ...' % service
    servicePath = '../{:s}'.format(service)
    if os.path.exists(servicePath):
      shutil.rmtree(servicePath)
    print 'Delete metainfo for service %s done' % service

def replaceServicesInfo(services):
  print 'Replace metainfo for services ...'
  for service in services:
    name = service['name']

    if service.has_key('friendlyName'):
      friendlyName = service['friendlyName']
      file = r'/tmp/sed-manager-resources.sh'
      with open(file, 'a+') as f:
        f.write('sed -ir \'s/ {:s} / {:s} /gI\' PATH_TO_REPLACE/transwarp-*.properties\n'.format(name, friendlyName))
        f.write('sed -ir \'s/^{:s} /{:s} /gI\' PATH_TO_REPLACE/transwarp-*.properties\n'.format(name, friendlyName))
        f.write('sed -ir \'s/ {:s}$/ {:s}/gI\' PATH_TO_REPLACE/transwarp-*.properties\n'.format(name, friendlyName))

    print 'Replace service name and role name for %s ...' % name
    for (path, dirs, files) in os.walk('../{:s}/'.format(name)):
      if 'metainfo.yaml' in files:
        filename = os.path.join(path, 'metainfo.yaml')
        with open(filename, 'r') as f:
          meta = yaml.safe_load(f)
        f = open(filename,'r')
        filedata = f.read()
        f.close()

        #replace service friendlyName
        if service.has_key('friendlyName'):
          pattern = r'friendlyName:\s+["|\']?{:s}["|\']?$'.format(meta['friendlyName'])
          repl = 'friendlyName: {:s}'.format(service['friendlyName'])
          filedata = re.sub(pattern, repl, filedata, flags=re.M)
        #replace service namePrefix
        if service.has_key('namePrefix'):
          pattern = r'namePrefix:\s+["|\']?{:s}["|\']?$'.format(meta['namePrefix'])
          repl = 'namePrefix: "{:s}"'.format(service['namePrefix'])
          filedata = re.sub(pattern, repl, filedata, flags=re.M)

        if service.has_key('roles'):
          if meta.has_key('roleGroups'):
            for group in meta['roleGroups']:
              for role in group['roles']:
                for r in service['roles']:
                  if (role['name'] == r['name']):
                    #replace role friendlyName
                    if role.has_key('friendlyName') and r.has_key('friendlyName'):
                      pattern = r'friendlyName:\s+["|\']?{:s}["|\']?$'.format(role['friendlyName'])
                      repl = 'friendlyName: "{:s}"'.format(r['friendlyName'])
                      filedata = re.sub(pattern, repl, filedata, flags=re.M)
                    #replace role labelPrefix
                    if role.has_key('labelPrefix') and r.has_key('labelPrefix'):
                      pattern = r'labelPrefix:\s+["|\']?{:s}["|\']?$'.format(role['labelPrefix'])
                      repl = 'labelPrefix: "{:s}"'.format(r['labelPrefix'])
                      filedata = re.sub(pattern, repl, filedata, flags=re.M)
          for role in meta['roles']:
            for r in service['roles']:
              if (role['name'] == r['name']):
                #replace role friendlyName
                if role.has_key('friendlyName') and r.has_key('friendlyName'):
                  pattern = r'friendlyName:\s+["|\']?{:s}["|\']?$'.format(role['friendlyName'])
                  repl = 'friendlyName: "{:s}"'.format(r['friendlyName'])
                  filedata = re.sub(pattern, repl, filedata, flags=re.M)
                #replace role labelPrefix
                if role.has_key('labelPrefix') and r.has_key('labelPrefix'):
                  pattern = r'labelPrefix:\s+["|\']?{:s}["|\']?$'.format(role['labelPrefix'])
                  repl = 'labelPrefix: "{:s}"'.format(r['labelPrefix'])
                  filedata = re.sub(pattern, repl, filedata, flags=re.M)

        #write back metainfo.yaml after modified
        f = open(filename,'w')
        f.write(filedata)
        f.close()

        #replace configuration.yaml
        if service.has_key('configurations'):
          filename = os.path.join(path, 'configuration.yaml')
          with open(filename, 'r') as f:
            configs = yaml.safe_load(f)
          f = open(filename,'r')
          filedata = f.read()
          f.close()

          #replace service configurations
          for cfg in service['configurations']:
            for config in configs:
              if cfg['name'] == config['name']:
                for key, value in cfg.items():
                  if key != 'name':
                    pattern = r'{:s}:\s+["|\']?{:s}["|\']?$'.format(key, config[key])
                    repl = '{:s}: {:s}'.format(key, cfg[key])
                    filedata = re.sub(pattern, repl, filedata, flags=re.M)
          #write back configuration.yaml after modified
          f = open(filename,'w')
          f.write(filedata)
          f.close()

        #replace service description
        if service.has_key('i18n'):
          for file in service['i18n']:
            filename = os.path.join(path, 'i18n/{:s}'.format(file))
            f = open(filename,'r')
            filedata = f.read()
            f.close()
            for entry in service['i18n'][file]:
              for key in entry:
                value = entry[key]
                pattern = r'^{:s}=.+$'.format(key)
                repl = '{:s}={:s}'.format(key, json.dumps(value).replace('"', ''))
                filedata = re.sub(pattern, repl, filedata, flags=re.M)

            f = open(filename,'w')
            f.write(filedata)
            f.close()
  print 'Replace metainfo for services finished.'

# some services under manager uses the image of other product line,
# so the docker image tag should be replaced with oem product tag
# for example, license service use zk image
def replaceDockerImageTagWithProductTag(company, managerTag, productTag):
  print 'Replace service docker image tag with oem product tag ...'
  for service in os.listdir('../'):
    servicePath = '../{:s}'.format(service)
    if not os.path.isdir(servicePath):
      continue

    for version in os.listdir(servicePath):
      # only replace target version
      if version != managerTag:
        continue

      metaDir = os.path.join(servicePath, version)
      if not os.path.isdir(metaDir):
        continue

      filePath = os.path.join(metaDir, 'metainfo.yaml')
      if os.path.exists(filePath):
        f = open(filePath, 'r')
        filedata = f.read()
        f.close()

        pattern = ':{:s}-\d+.\d+.\d+-\w+'.format(company)
        repl = ':{:s}'.format(productTag)
        filedata = re.sub(pattern, repl, filedata, flags=re.M)

        f = open(filePath, 'w')
        f.write(filedata)
        f.close()
  print 'Replace service docker image tag with oem product tag finished.'
  print 'Replace transwarp tag with oem product tag ...'
  for (path, dirs, files) in os.walk('../', topdown=False):
    if('__' in path):
      continue
    if('resources' in path):
      continue
    if('i18n' in path):
      continue
    if(r'.git' in path):
      continue

    for file in files:
      if file == 'release-date.csv':
         continue

      filePath = os.path.join(path, file)
      f = open(filePath,'r')
      filedata = f.read()
      f.close()

      pattern = 'transwarp-\d+.\d+(.\d+-\w+)?'
      filedata = re.sub(pattern, productTag, filedata, flags=re.M)

      f = open(filePath, 'w')
      f.write(filedata)
      f.close()
  print 'Replace service docker image tag with oem product tag finished.'


#for yaml load custom tags
class GenericMapping:
  def __init__(self, mapping, tag, flow_style=None):
    self._mapping = mapping
    self._tag = tag
    self._flow_style = flow_style

  @staticmethod
  def to_yaml(dumper, data):
    return dumper.represent_mapping(u'!<%s>' % data._tag, data._mapping, style=data._flow_style)


def default_constructor(loader, tag_suffix, node):
  if isinstance(node, yaml.MappingNode):
    #mapping = loader.construct_mapping(node, deep=True)
    return GenericMapping(None, tag_suffix, flow_style=node.flow_style)
  else:
    raise NotImplementedError('Node: ' + str(type(node)))


if __name__ == "__main__":
  company = sys.argv[1]
  file = company + '/application-metainfo/oem.yaml'

  if os.path.exists(file):
    yaml.add_multi_constructor('', default_constructor, Loader=yaml.SafeLoader)
    #yaml.add_representer(GenericMapping, GenericMapping.to_yaml, Dumper=yaml.SafeDumper)

    with open(file, 'r') as f:
      conf = yaml.safe_load(f)

    if conf.has_key('products'):
      replaceProductsInfo(conf['products'])
    if conf.has_key('deleteServices'):
      deleteServicesMeta(conf['deleteServices'])
    if conf.has_key('reserveTags'):
      replaceReservedTagsAndDeleteOthers(conf['reserveTags'])
    if conf.has_key('services'):
      replaceServicesInfo(conf['services'])
    if conf.has_key('tags'):
      replaceVersionTags(conf['tags'])
    replaceMetainfoWithLatestVersion()
    managerTag = sys.argv[2]
    productTag = sys.argv[3]
    replaceDockerImageTagWithProductTag(company, managerTag, productTag)

    serviceMetaBaseDir = company + '/application-metainfo/'
    replaceServiceResources(serviceMetaBaseDir)