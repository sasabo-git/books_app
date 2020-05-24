# frozen_string_literal: true

class RenameImageableIdColumnToComments < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :imageable_id, :commentable_id
  end
end
