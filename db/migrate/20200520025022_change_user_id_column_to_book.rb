# frozen_string_literal: true

class ChangeUserIdColumnToBook < ActiveRecord::Migration[6.0]
  def change
    change_column_null :books, :user_id, false, 0
  end
end
