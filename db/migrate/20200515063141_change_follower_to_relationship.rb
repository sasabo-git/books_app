# frozen_string_literal: true

class ChangeFollowerToRelationship < ActiveRecord::Migration[6.0]
  def change
    change_column_null :relationships, :follower_id, false, 0
  end
end
