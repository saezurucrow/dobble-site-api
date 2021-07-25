class CreateRankings < ActiveRecord::Migration[6.1]
  def change
    create_table :rankings do |t|
      t.string :name, :limit=>8
      t.float :score

      t.timestamps
    end
  end
end
