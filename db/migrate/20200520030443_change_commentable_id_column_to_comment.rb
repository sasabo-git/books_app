# frozen_string_literal: true

class ChangeCommentableIdColumnToComment < ActiveRecord::Migration[6.0]
  def change
    change_column_null :comments, :commentable_id, false, 0
  end
end
