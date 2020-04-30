# frozen_string_literal: true

class RenameIntroduceColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :introduce, :introduction
  end
end
