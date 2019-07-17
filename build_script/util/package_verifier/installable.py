#!/usr/bin/env python3
import sys
import os
import json
import yaml
import shutil
"""
Grammar: sudo docker run -v $PWD:/tmp ubuntu:python3 /usr/local/bin/installable.py [package_numbers] [package_name] [package_name]...[comparison file]
[package_numbers] is the number of packages to be checked.
[package_name] is the name of package to be published, the order of packages is the order of decompression, package suffix is .gz.
[comparison file] is the name of comparison file, file suffix is .yaml and the format is 
- name: SLIPSTREAM
  version: transwarp-6.2.0-rc0
- name: INCEPTOR_GATEWAY
  version: transwarp-6.2.0-rc0
if services of comparison file are installable, the terminal print True, otherwise print False.
 
Among them, [comparison file] is optional.

There are a few points to note:
1. Due to the package pyyaml, when the .yaml file is being read, the characters following ! will be blanked.
2. Due to point 1, it is impossible to judge whether or not role is a optional role, so we will treat all roles
   as mandatory roles.
"""

PACKAGES_POSITION = '/tmp'
DATA_TEMP = '/dataTmp'
IMAGES_POSITION = 'images/index.json'
SERVICE_META_POSITION = 'service_meta'
SERVICE_META = 'metainfo.yaml'
QUALIFIERS = ["alpha", "beta", "milestone", "rc", "snapshot", "", "sp"]
ALIASES = {"ga": "", "final": "", "cr": "rc"}
RELEASE_VERSION_INDEX = QUALIFIERS.index("")


# Delete useless information: 010 -> 10
def normalize(version_list):
    i = -1
    while i >= -len(version_list):
        if version_list[i] == '0':
            version_list.pop(i)
        else:
            break


# Compare the sub-version: "beta">"alpha","final"=="","rc"<""
def compare_util(version_str_1, version_str_2):
    if version_str_2 is None:
        if version_str_1.isdigit() or qualifier(version_str_1) > RELEASE_VERSION_INDEX:
            return 1
        elif qualifier(version_str_1) == RELEASE_VERSION_INDEX:
            return 0
        else:
            return -1
    elif version_str_1.isdigit():
        if version_str_2.isdigit():
            if version_str_1 == version_str_2:
                return 0
            else:
                return 1 if version_str_1 > version_str_2 else -1
        else:
            return 1
    else:
        if version_str_2.isdigit():
            return -1
        else:
            if qualifier(version_str_1) == qualifier(version_str_2):
                return 0
            else:
                return 1 if qualifier(version_str_1) > qualifier(version_str_2) else -1


# Obtain the priority of version suffix:"alpha" -> 0,"beta" -> 1
def qualifier(version_str):
    if version_str in QUALIFIERS:
        return QUALIFIERS.index(version_str)
    elif ALIASES.get(version_str) is not None:
        return QUALIFIERS.index(ALIASES.get(version_str))
    else:
        return -1


# Parse version information into a list of comparable strings: transwarp-6.2.0-rc0 -> [transwarp,6,2,0,rc,0]
def parse_version(version):
    version = version.lower()
    version_list = []
    start_index = 0
    index = 0
    is_digit = False
    for s in version:
        if s == '.':
            if index == start_index:
                version_list.append(0)
            else:
                version_list.append(version[start_index:index])
            start_index = index + 1
        elif s == '-':
            if index == start_index:
                version_list.append(0)
            else:
                version_list.append(version[start_index:index])
            start_index = index + 1

            if is_digit:
                normalize(version_list)
        elif s.isdigit():
            if (not is_digit) and (index > start_index):
                if version[start_index] == 'a':
                    version_list.append('alpha')
                elif version[start_index] == 'b':
                    version_list.append('beta')
                elif version[start_index] == 'm':
                    version_list.append('milestone')
                else:
                    version_list.append(version[start_index:index])
                start_index = index
            is_digit = True
        else:
            if is_digit and index > start_index:
                version_list.append(version[start_index:index])
                start_index = index
            is_digit = False
        index += 1
    if len(version) > start_index:
        version_list.append(version[start_index:len(version)])
    normalize(version_list)
    return version_list


# Parse_version comparison
def compare(version_1, version_2):
    version_1 = str(version_1)
    version_2 = str(version_2)
    if version_2 is None:
        if len(version_1) == 0:
            return 0
        elif version_1[0] == "":
            return 0
        else:
            return 1
    index1 = 0
    index2 = 0
    while index1 < len(version_1) or index2 < len(version_2):
        left = version_1[index1] if index1 < len(version_1) else None
        right = version_2[index2] if index2 < len(version_2) else None
        result = (0 if right is None else -1 * compare_util(right, left)) if left is None else compare_util(left, right)
        if result != 0:
            return result
        index1 += 1
        index2 += 1
    return 0


# Version comparison
def version_compare(version_1, version_2):
    version_1 = parse_version(version_1)
    version_2 = parse_version(version_2)
    return compare(version_1, version_2)


# Whether the service can be installed
def is_installable(service, services_meta, images_set):
    state = service.get('state')
    if state != 0:
        return state
    self_docker_image = service.get('dockerImage')
    if (self_docker_image is not None) and (not self_docker_image in images_set):
        # print('name:' + str(service.get('name')) + ',version:' + str(service.get('version')))
        # print("No self dockerImage:" + self_docker_image)
        service['state'] = -1
        return -1
    roles = service.get('roles')
    for role in roles:
        if role.__contains__('dockerImage') and not role.get('dockerImage') in images_set:
            print('Name:' + str(service.get('name')) + ',version:' + str(service.get('version')))
            print("no roles:" + "name:" + str(role.get('name')) + ",DockerImage:" + str(role.get('dockerImage')))
            service['state'] = -1
            return -1
    for dependencie in service.get('dependencies'):
        if dependencie.__contains__('optional') and dependencie.get('optional') is False:
            dependencieName = dependencie.get('name')
            min_version = None if not dependencie.__contains__('minVersion') else dependencie.get('minVersion')
            max_version = None if not dependencie.__contains__('maxVersion') else dependencie.get('maxVersion')
            if min_version is None and max_version is not None:
                if dependencie_is_installable_3(dependencieName, max_version, services_meta, images_set) == -1:
                    print('Name:' + str(service.get('name')) + ',version:' + str(service.get('version')))
                    print("No dependencie:" + "name:" + str(dependencie.get('name')) + ",maxVersion:" + max_version)
                    service['state'] = -1
                    return -1
            elif min_version is not None and max_version is None:
                if dependencie_is_installable_2(dependencieName, min_version, services_meta, images_set) == -1:
                    print('Name:' + str(service.get('name')) + ',version:' + str(service.get('version')))
                    print("No dependencie:" + "name:" + str(dependencie.get('name')) + ",minVersion:" + min_version)
                    service['state'] = -1
                    return -1
            elif min_version is not None and max_version is not None:
                if dependencie_is_installable_1(dependencieName, min_version, max_version, services_meta,
                                                images_set) == -1:
                    print('Name:' + str(service.get('name')) + ',version:' + str(service.get('version')))
                    print("No dependencie:" + "name:" + str(
                        dependencie.get('name')) + ",minVersion:" + min_version + ",maxVersion:" + max_version)
                    service['state'] = -1
                    return -1
            elif dependencie_is_installable_0(dependencieName, services_meta, images_set) == -1:
                print('Name:' + str(service.get('name')) + ',version:' + str(service.get('version')))
                print("No dependencie:" + "name:" + str(dependencie.get('name')))
                service['state'] = -1
                return -1
                #    print('success')
    service['state'] = 1
    return 1


def dependencie_is_installable_0(name, services_meta, images_set):
    for service in services_meta:
        if service.get('name') == name:
            state = service.get('state')
            if state == 1 or is_installable(service, services_meta, images_set) == 1:
                return 1
    return -1


# Whether the dependencie of service can be installed in case of limiting the maximum version and the minimum version
def dependencie_is_installable_1(name, min_version, max_version, services_meta, images_set):
    for service in services_meta:
        if (compare(service.get('version'), min_version) >= 0) and (compare(service.get('version'), max_version) <= 0):
            if service.get('name') == name:
                state = service.get('state')
                if state == 1 or is_installable(service, services_meta, images_set) == 1:
                    return 1
    return -1


# Whether the dependencie of service can be installed in case of limiting the minimum version
def dependencie_is_installable_2(name, min_version, services_meta, images_set):
    for service in services_meta:
        if service.get('name') == name:
            if compare(service.get('version'), min_version) >= 0:
                state = service.get('state')
                if state == 1 or is_installable(service, services_meta, images_set) == 1:
                    return 1
    return -1


# Whether the dependencie of service can be installed in case of limiting the maximum version
def dependencie_is_installable_3(name, max_version, services_meta, images_set):
    for service in services_meta:
        if service.get('name') == name:
            if compare(service.get('version'), max_version) <= 0:
                state = service.get('state')
                if state == 1 or is_installable(service, services_meta, images_set) == 1:
                    return 1
    return -1


index = 1
images_set = set()

if (sys.argv[index] is None) or (not sys.argv[index].isdigit()):
    print('Input is invalid')
    sys.exit()
else:
    package_num = int(sys.argv[index])
    index += 1
    if index + package_num > len(sys.argv):
        print('Out of index')
        sys.exit()
    for i in range(index, index + package_num):
        if os.path.splitext(sys.argv[i])[1] != '.gz' or (not os.path.exists(PACKAGES_POSITION + '/' + sys.argv[i])):
            print('Invalid filename:' + sys.argv[i])
            sys.exit()
    if not os.path.exists(PACKAGES_POSITION + DATA_TEMP):
        os.mkdir(PACKAGES_POSITION + DATA_TEMP)

    for i in range(index, index + package_num):
        print('tar:' + sys.argv[i])
        os.system(
            'tar -zxvf ' + PACKAGES_POSITION + '/' + sys.argv[
                i] + ' -C ' + PACKAGES_POSITION + DATA_TEMP + " " + IMAGES_POSITION + " " + SERVICE_META_POSITION)
        if os.path.exists(PACKAGES_POSITION + DATA_TEMP + '/' + IMAGES_POSITION):
            with open(PACKAGES_POSITION + DATA_TEMP + '/' + IMAGES_POSITION) as f:
                imagesJson = json.load(f)
                manifests = imagesJson.get('manifests')
                for manifest in manifests:
                    images_set.add(manifest.get('annotations').get('org.opencontainers.image.ref.name'))
    index = index + package_num
    print("Available image:" + str(images_set))

try:
    yaml.add_multi_constructor('', lambda loader, suffix, node: None)

    services_meta = []

    for root, dirs, files in os.walk(PACKAGES_POSITION+ DATA_TEMP):
        for name in files:
            if name == SERVICE_META:
                with open(os.path.join(root, name), 'r') as f:
                    temp_meta = yaml.load(f.read(), Loader=yaml.Loader)
                    temp_dir = {}
                    print(os.path.join(root, name))
                    temp_dir['name'] = temp_meta.get('name')
                    temp_dir['version'] = temp_meta.get('version')
                    temp_dir['dockerImage'] = temp_meta.get('dockerImage')
                    temp_dir['dependencies'] = temp_meta.get('dependencies')
                    temp_dir['roles'] = temp_meta.get('roles')
                    temp_dir['state'] = 0
                    services_meta.append(temp_dir)

    for service in services_meta:
        is_installable(service, services_meta, images_set)

    installable_service = []
    print("Installable service:")
    for service in services_meta:
        if service.get('state') == 1:
            installable_service.append(service)
            print('name:' + str(service.get('name')) + ',version:' + str(service.get('version')))

    all_service_flag = 1
    service_flag = 0
    if index < len(sys.argv):
        if (os.path.splitext(sys.argv[index])[1] != '.yaml') or (
                not os.path.exists(PACKAGES_POSITION + '/' + sys.argv[index])):
            print('Invalid comparison file')
            sys.exit()
        else:
            print('Comparison detail:')
            with open(PACKAGES_POSITION + '/' + sys.argv[index], 'r') as f:
                comparison_meta = yaml.load(f.read(), Loader=yaml.Loader)
            for meta in comparison_meta:
                for service in installable_service:
                    if service.get('name') == meta.get('name') and service.get('version') == meta.get('version'):
                        service_flag = 1
                        print(meta.get('name') + ',' + meta.get('version') + ' is installable')
                        break
                if service_flag == 1:
                    service_flag = 0
                else:
                    all_service_flag = 0
                    print(meta.get('name') + ',' + meta.get('version') + ' is not installable')
            print(True if all_service_flag == 1 else False)
finally:
    if os.path.exists(PACKAGES_POSITION + DATA_TEMP):
        shutil.rmtree(PACKAGES_POSITION + DATA_TEMP)
        print('Delete' + PACKAGES_POSITION + DATA_TEMP)
