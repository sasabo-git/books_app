# frozen_string_literal: true

class AddZipToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :zip, :varchar
  end
end
