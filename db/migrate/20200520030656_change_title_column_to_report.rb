# frozen_string_literal: true

class ChangeTitleColumnToReport < ActiveRecord::Migration[6.0]
  def change
    change_column_null :reports, :title, false, 0
  end
end
