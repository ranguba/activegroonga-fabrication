#!/usr/bin/env ruby
#
# Copyright (C) 2011  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License version 2.1 as published by the Free Software Foundation.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

$VERBOSE = true

require 'pathname'
require 'shellwords'

base_dir = Pathname(__FILE__).dirname.parent.expand_path

rroonga_dir = base_dir.parent + "rroonga"
lib_dir = base_dir + "lib"
test_dir = base_dir + "test"

if rroonga_dir.exist?
  make = nil
  if system("which gmake > /dev/null")
    make = "gmake"
  elsif system("which make > /dev/null")
    make = "make"
  end
  if make
    escaped_rroonga_dir = Shellwords.escape(rroonga_dir.to_s)
    system("cd #{escaped_rroonga_dir} && #{make} > /dev/null") or exit(false)
  end
  $LOAD_PATH.unshift(rroonga_dir + "ext" + "groonga")
  $LOAD_PATH.unshift(rroonga_dir + "lib")
end

active_groonga_dir = base_dir.parent + "activegroonga"
if active_groonga_dir.exist?
  $LOAD_PATH.unshift(active_groonga_dir + "lib")
end

ENV["TEST_UNIT_MAX_DIFF_TARGET_STRING_SIZE"] = "10000"

gem 'test-unit-notify'
require 'test/unit'
require 'test/unit/notify'
Test::Unit::Priority.enable
Test::Unit::Notify.enable = true

$LOAD_PATH.unshift(lib_dir)

$LOAD_PATH.unshift(test_dir)
require 'active-groonga-fabrication-test-utils'

Dir.glob("test/**/test{_,-}*.rb") do |file|
  require file.sub(/\.rb$/, '')
end

exit Test::Unit::AutoRunner.run(false)
