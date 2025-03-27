class RemoveUserInfoToReservation < ActiveRecord::Migration[7.1]
  def change
    remove_column :reservations, :name
    remove_column :reservations, :email
  end
end
