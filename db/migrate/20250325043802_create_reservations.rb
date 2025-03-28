class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date :date, null: false
      t.references :schedule, null: false, foreign_key: true
      t.references :sheet, null: false, foreign_key: true
      t.string :email, null: false
      t.string :name, null: false
      t.timestamps

      t.index [:date, :schedule_id, :sheet_id, :screen_id], unique: true
    end
  end
end
