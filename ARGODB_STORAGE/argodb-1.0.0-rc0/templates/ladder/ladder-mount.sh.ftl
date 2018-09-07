#!/usr/bin/env bash
#
# The Ladder Open Foundation licenses this work under the Apache License, version 2.0
# (the "License"). You may not use this work except in compliance with the License, which is
# available at www.apache.org/licenses/LICENSE-2.0
#
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied, as more fully set forth in the License.
#
# See the NOTICE file distributed with this work for information regarding copyright ownership.
#

# Starts the Ladder master on this node.
# Starts an Ladder worker on each node specified in conf/workers

<#noparse>

function mount_ramfs_linux() {
  local total_mem=$(($(cat /proc/meminfo | awk 'NR==1{print $2}') * 1024))
  if [[ ${total_mem} -lt ${MEM_SIZE} ]]; then
    echo "ERROR: Memory(${total_mem}) is less than requested ramdisk size(${MEM_SIZE}). Please
    reduce ladder.worker.memory.size in ladder-site.properties" >&2
    exit 1
  fi

  echo "Formatting RamFS: ${TIER_PATH} (${MEM_SIZE})"
  if mount | grep ${TIER_PATH} > /dev/null; then
    if [[ "$1" == "SudoMount" ]]; then
      sudo umount -l -f ${TIER_PATH}
    else
      umount -l -f ${TIER_PATH}
    fi
    if [[ $? -ne 0 ]]; then
      echo "ERROR: umount RamFS ${TIER_PATH} failed" >&2
      exit 1
    fi
  else
    if [[ "$1" == "SudoMount" ]]; then
      sudo mkdir -p ${TIER_PATH}
    else
      mkdir -p ${TIER_PATH}
    fi
    if [[ $? -ne 0 ]]; then
      echo "ERROR: mkdir ${TIER_PATH} failed" >&2
      exit 1
    fi
  fi

  if [[ "$1" == "SudoMount" ]]; then
    sudo mount -t ramfs -o size=${MEM_SIZE} ramfs ${TIER_PATH}
  else
    mount -t ramfs -o size=${MEM_SIZE} ramfs ${TIER_PATH}
  fi
  if [[ $? -ne 0 ]]; then
    echo "ERROR: mount RamFS ${TIER_PATH} failed" >&2
    exit 1
  fi

  if [[ "$1" == "SudoMount" ]]; then
    sudo chmod a+w ${TIER_PATH}
  else
    chmod a+w ${TIER_PATH}
  fi
  if [[ $? -ne 0 ]]; then
    echo "ERROR: chmod RamFS ${TIER_PATH} failed" >&2
    exit 1
  fi
}

</#noparse>

export TIER_PATH=${service['ladder.worker.mem.data_path']}
export MEM_SIZE=${service['ladder.worker.mem.size']}
mount_ramfs_linux SudoMount
