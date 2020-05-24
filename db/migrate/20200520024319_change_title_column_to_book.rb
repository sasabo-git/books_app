# frozen_string_literal: true

class ChangeTitleColumnToBook < ActiveRecord::Migration[6.0]
  def change
    change_column_null :books, :title, false, 0
  end
end
