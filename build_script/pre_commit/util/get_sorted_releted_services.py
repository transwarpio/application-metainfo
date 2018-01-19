import sys
import os
import re
import yaml

g_dep_map = {}
g_reverse_dep_map = {}
g_global_services = {}

def print_usage():
  print "usage: ", __file__, "METAROOT", "VERSION", "SERVICE..."

def construct_graph(meta_dir, version):

  for service in os.listdir(meta_dir):
    metainfo_path = os.path.join(meta_dir, service, version, "metainfo.yaml")
    if os.path.exists(metainfo_path):
      with open(metainfo_path) as file:
        meta = yaml.load(re.sub('!<[^>]*>', '', file.read()))

      if meta['global']:
        g_global_services[service] = True

      for dep in meta['dependencies']:
        if 'preferred' in dep and not dep['preferred']:
          continue
        if not service in g_dep_map:
          g_dep_map[service] = []
        g_dep_map[service].append(dep['name'])

        if not dep['name'] in g_reverse_dep_map:
          g_reverse_dep_map[dep['name']] = []
        g_reverse_dep_map[dep['name']].append(service)


def get_affected_services(services):
  related_service_set = {}
  def dfs(service):
    if service in related_service_set:
      return
    related_service_set[service] = True

    if service in g_reverse_dep_map:
      for rdep in g_reverse_dep_map[service]:
        if rdep not in related_service_set:
          dfs(rdep)

  for service in services:
    dfs(service)

  return list(related_service_set.keys())


def get_start_sequence(services):
  start_sequence = []
  def dfs(service):
    if service in start_sequence:
      return
    if service in g_dep_map:
      for dep in g_dep_map[service]:
        if not dep in start_sequence:
          dfs(dep)

    start_sequence.append(service)

  for service in services:
    dfs(service)

  return [s for s in start_sequence if s not in g_global_services]


if __name__ == '__main__':
  if len(sys.argv) < 2:
    print_usage()
    sys.exit(1)

  meta_root = sys.argv[1]
  version = sys.argv[2]
  input = sys.argv[3:]

  construct_graph(meta_root, version)
  related_services = get_affected_services(input)
  start_sequence = get_start_sequence(related_services)
  print ' '.join(start_sequence)
