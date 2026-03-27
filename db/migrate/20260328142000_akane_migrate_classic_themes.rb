# frozen_string_literal: true

class AkaneMigrateClassicThemes < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  # Dummy classes, to make migration possible across version changes
  class User < ApplicationRecord; end

  def up
    User.where.not(settings: nil).find_each do |user|
      settings = JSON.parse(user.attributes_before_type_cast['settings'])
      next if settings.nil? || settings['theme'].blank?
      next unless settings['theme'] == 'classic'

      settings['theme'] = 'akane-blue'

      user.update_column('settings', JSON.generate(settings))
    end
  end
end