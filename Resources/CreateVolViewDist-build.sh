#!/bin/bash

# SPDX-FileCopyrightText: 2023 Sebastien Jodogne, UCLouvain, Belgium
# SPDX-License-Identifier: GPL-3.0-or-later

# Kitware's VolView plugin for Orthanc
# Copyright (C) 2023 Sebastien Jodogne, UCLouvain, Belgium
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

set -ex

if [ "$1" = "" ]; then
    echo "Please provide a version number of VolView"
    exit -1
fi

apt update
apt install patch

cd /tmp/
tar xvf /source/VolView-$1.tar.gz

cd /tmp/VolView-$1
patch -p1 < /source/VolView-$1.patch
npm install --cache /tmp/npm-cache
npm run build --cache /tmp/npm-cache

cp -r /tmp/VolView-$1/dist/* /target
