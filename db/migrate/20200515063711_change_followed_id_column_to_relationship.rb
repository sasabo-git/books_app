# frozen_string_literal: true

class ChangeFollowedIdColumnToRelationship < ActiveRecord::Migration[6.0]
  def change
    change_column_null :relationships, :followed_id, false, 0
  end
end
