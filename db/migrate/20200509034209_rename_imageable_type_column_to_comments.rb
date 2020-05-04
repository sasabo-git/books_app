# frozen_string_literal: true

class RenameImageableTypeColumnToComments < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :imageable_type, :commentable_type
  end
end
