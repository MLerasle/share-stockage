class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :advert_id
      t.integer :score
      t.text :comment
      t.boolean :validated
      
      t.timestamps
    end
  end
end
