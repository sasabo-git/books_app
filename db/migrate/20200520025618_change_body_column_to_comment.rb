# frozen_string_literal: true

class ChangeBodyColumnToComment < ActiveRecord::Migration[6.0]
  def change
    change_column_null :comments, :body, false, 0
  end
end
