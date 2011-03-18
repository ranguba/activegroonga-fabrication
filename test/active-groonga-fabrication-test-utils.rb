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

require 'fileutils'
require 'pathname'

require 'active_groonga_fabrication'

module ActiveGroongaFabricationTestUtils
  class << self
    def included(base)
      base.setup :setup_sand_box, :before => :prepend
      base.teardown :teardown_sand_box, :after => :append
    end
  end

  def setup_sand_box
    Groonga::Context.default = nil
    @context = Groonga::Context.default

    setup_tmp_directory
    setup_database_directory
    setup_database

    setup_users_table
  end

  def setup_tmp_directory
    @tmp_dir = Pathname(File.dirname(__FILE__)) + "tmp"
    FileUtils.rm_rf(@tmp_dir.to_s)
    FileUtils.mkdir_p(@tmp_dir.to_s)
  end

  def setup_database_directory
    @database_dir = @tmp_dir + "groonga"
    FileUtils.mkdir_p(@database_dir.to_s)
  end

  def setup_database
    @database_path = @database_dir + "database"
    @database = Groonga::Database.create(:path => @database_path.to_s)
    ActiveGroonga::Base.database_path = @database_path.to_s
  end

  def setup_tables_directory
    @tables_dir = Pathname("#{@database_path}.tables")
    FileUtils.mkdir_p(@tables_dir.to_s)
  end

  def setup_users_table
    ActiveGroonga::Schema.define do |schema|
      schema.create_table(:users) do |table|
        table.short_text :name
      end
    end
  end

  def teardown_sand_box
    teardown_tmp_directory
  end

  def teardown_tmp_directory
    FileUtils.rm_rf(@tmp_dir.to_s)
  end
end

require 'models/user'
