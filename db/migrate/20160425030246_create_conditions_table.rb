class CreateConditionsTable < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :sailing_time
      t.integer :cars_percentage
      t.integer :trucks_percentage
      t.integer :total_percentage
    end
  end
end
