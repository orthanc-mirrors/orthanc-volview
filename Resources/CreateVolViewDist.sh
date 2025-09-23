#!/bin/bash

# SPDX-FileCopyrightText: 2023-2025 Sebastien Jodogne, ICTEAM UCLouvain, Belgium
# SPDX-License-Identifier: GPL-3.0-or-later

# Kitware's VolView plugin for Orthanc
# Copyright (C) 2023-2025 Sebastien Jodogne, ICTEAM UCLouvain, Belgium
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.



# This command-line script uses the "npm" tool to populate the "dist"
# folder of VolView. It uses Docker to this end, in order to be usable
# on our CIS.

set -e

if [ "$1" = "" ]; then
    VERSION=4.4.0
    EXPECTED_MD5="88f6bef9a4ccb637d1db863b378462f1"
else
    VERSION=$1
fi

if [ -t 1 ]; then
    # TTY is available => use interactive mode
    DOCKER_FLAGS='-i'
fi

ROOT_DIR=`dirname $(readlink -f $0)`/..
IMAGE=orthanc-volview-node

echo "Creating the distribution of VolView $VERSION"

if [ -e "${ROOT_DIR}/VolView/dist/" ]; then
    echo "Target folder is already existing, aborting"
    exit -1
fi

if [ ! -f "${ROOT_DIR}/VolView/VolView-${VERSION}.tar.gz" ]; then
    ( cd ${ROOT_DIR}/VolView && \
          wget https://orthanc.uclouvain.be/downloads/third-party-downloads/VolView-${VERSION}.tar.gz )
fi

ACTUAL_MD5=`md5sum "${ROOT_DIR}/VolView/VolView-${VERSION}.tar.gz" | cut -d ' ' -f1`
if [ "${EXPECTED_MD5}" != "" -a "${ACTUAL_MD5}" != "${EXPECTED_MD5}" ]; then
    echo "Bad hash for file: ${ROOT_DIR}/VolView/VolView-${VERSION}.tar.gz"
    exit -1
fi

mkdir -p ${ROOT_DIR}/VolView/dist/

( cd ${ROOT_DIR}/Resources/CreateVolViewDist && \
      docker build --network=host --no-cache -t ${IMAGE} . )

docker run -t ${DOCKER_FLAGS} --rm \
       --user $(id -u):$(id -g) \
       -v ${ROOT_DIR}/Resources/CreateVolViewDist/build.sh:/source/build.sh:ro \
       -v ${ROOT_DIR}/VolView/VolView-${VERSION}.tar.gz:/source/VolView-${VERSION}.tar.gz:ro \
       -v ${ROOT_DIR}/VolView/dist/:/target:rw \
       ${IMAGE} \
       bash /source/build.sh ${VERSION}
