class RenameTicketIdOnRegistration < ActiveRecord::Migration[5.0]
  def change
    remove_index :registrations,:ticked_id
    rename_column :registrations, :ticked_id, :ticket_id
    add_index :registrations,:ticket_id
  end
end
