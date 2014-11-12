class CreateKendocupKenshis < ActiveRecord::Migration
  def change
    create_table :kendocup_kenshis do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :female
      t.belongs_to :cup, index: true
      t.belongs_to :user, index: true
      t.date :dob
      t.belongs_to :club, index: true
      t.string :email
      t.string :grade

      t.timestamps
    end
    add_index :kendocup_kenshis, :last_name
    add_index :kendocup_kenshis, :grade
  end
end