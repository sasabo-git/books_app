# frozen_string_literal: true

class AddAddressToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :address, :string
  end
end
