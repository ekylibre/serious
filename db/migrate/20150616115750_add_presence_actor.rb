class AddPresenceActor < ActiveRecord::Migration
  def change
    add_column :participants, :isPresence, :boolean, :default => true
    add_column :participants, :locationEvent, :string, :null => true
  end
end
