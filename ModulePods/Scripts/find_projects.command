#!/bin/sh

#  find_projects.command
#  ModulePods
#
#  Created by Alberto De Bortoli on 15/09/2019.
#  Copyright © 2019 Alberto De Bortoli. All rights reserved.

find ~/${1} -type f -name 'Podfile' | sed -E 's|/[^/]+$||' | sort -u
