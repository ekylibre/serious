class AddPresenceActor < ActiveRecord::Migration
  def change
    add_column :participants, :present, :boolean, null: false, default: false
    add_column :participants, :stand_number, :string
  end
end
