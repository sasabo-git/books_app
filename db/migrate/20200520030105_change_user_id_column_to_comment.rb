# frozen_string_literal: true

class ChangeUserIdColumnToComment < ActiveRecord::Migration[6.0]
  def change
    change_column_null :comments, :user_id, false, 0
  end
end
