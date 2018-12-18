import os, re, sys
import json, yaml

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
        pattern = r':{:s}-'.format(tag['original'])
        repl = r':{:s}-'.format(tag['replacement'])
        filedata = re.sub(pattern, repl, filedata, flags=re.M)

        #replace meta versions
        pattern = r':\s+{:s}-'.format(tag['original'])
        repl = r': {:s}-'.format(tag['replacement'])
        filedata = re.sub(pattern, repl, filedata, flags=re.M)

        #replace release date
        pattern = r',{:s}-'.format(tag['original'])
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
        os.rename(os.path.join(path, dir), os.path.join(path, dirname))
  print 'Replace service version and images tags finished.'

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

def replaceServicesInfo(services):
  print 'Replace metainfo for services ...'
  for service in services:
    name = service['name']
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
            for role in meta['roleGroups']['roles']:
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
    if conf.has_key('services'):
      replaceServicesInfo(conf['services'])
    if conf.has_key('tags'):
      replaceVersionTags(conf['tags'])