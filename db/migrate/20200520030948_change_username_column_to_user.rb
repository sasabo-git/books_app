# frozen_string_literal: true

class ChangeUsernameColumnToUser < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :username, false, 0
  end
end
