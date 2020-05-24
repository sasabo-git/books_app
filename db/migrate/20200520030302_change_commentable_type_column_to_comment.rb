# frozen_string_literal: true

class ChangeCommentableTypeColumnToComment < ActiveRecord::Migration[6.0]
  def change
    change_column_null :comments, :commentable_type, false, 0
  end
end
