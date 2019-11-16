#!/bin/sh

#  pod_update.command
#  ModulePods
#
#  Created by Alberto De Bortoli on 15/09/2019.
#  Copyright © 2019 Alberto De Bortoli. All rights reserved.

cd ~/Repos/${1}/Example
export PATH=/Users/alberto.debortoli/.rvm/gems/ruby-2.5.3/bin:$PATH
export PATH=/Users/alberto.debortoli/.rvm/gems/ruby-2.5.3@global/bin:$PATH
export PATH=/Users/alberto.debortoli/.rvm/rubies/ruby-2.5.3/bin:$PATH

export LANG=en_US.UTF-8
bundle exec pod update
