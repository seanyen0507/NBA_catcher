class CreateNbaplayers < ActiveRecord::Migration
  def self.up
  	create_table :nbaplayers do |t|
  		t.string :description
  		t.text :playernames
  		t.timestamps
  	end
  end

  def self.down
  	drop_table :nbaplayers;
  end
end
