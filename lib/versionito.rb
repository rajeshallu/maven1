require "versionito/version"
require "active_support/concern"
require "active_support/inflector"

module Versionito
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :versions, {
      class_name: self.to_s,
      join_table: versions_table_name,
      foreign_key: foreign_key,
      association_foreign_key: association_foreign_key,
      auto_save: true,
    }

    after_initialize do
      setup_new_version(self) if self.new_record?
    end
  end

  def initialize_version!
    self.version = self.versions.length
  end

  def new_version
    self.dup.tap do |obj|
      setup_new_version(obj)

      yield(obj, self) if block_given?
    end
  end

  def setup_new_version(obj)
    obj.versions = self.versions
    obj.versions << obj unless obj.versions.include?(obj)
    obj.initialize_version!
  end

  module ClassMethods
    def foreign_key
      "%s_id" % self.table_name.singularize
    end

    def association_foreign_key
      "version_id"
    end

    def versions_table_name
      "%s_versions" % self.table_name.singularize
    end
  end
end
