#!/usr/bin/env bash

# Setup script for librealsense.
#
# Roberto Masocco <r.masocco@dotxautomation.com>
#
# September 15, 2024

# Copyright 2024 dotX Automation s.r.l.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# shellcheck disable=SC2207,SC2016

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

ARCH="$(uname -m)"

if [[ "${ARCH}" == "x86_64" ]]; then
  echo "Installing for ${ARCH} architecture"
  sleep 2

  # Register the server's public key and add the server to the list of repositories
  sudo mkdir -p /etc/apt/keyrings
  curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | sudo tee /etc/apt/keyrings/librealsense.pgp > /dev/null
  sudo apt-get install -y apt-transport-https
  echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/librealsense.list
  sudo apt-get update

  # Install librealsense packages
  sudo apt-get install -y librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg
elif [[ "${ARCH}" == "aarch64" ]]; then
  echo "Installing for ${ARCH} architecture"
  sleep 2

  # Register the server's public key and add the server to the list of repositories
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || \
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
  sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u

  # Install librealsense packages
  sudo apt-get install -y librealsense2-utils librealsense2-dev librealsense2-dbg
else
  echo "Unsupported architecture: ${ARCH}"
  exit 1
fi
