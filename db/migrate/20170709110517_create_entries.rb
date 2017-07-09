class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.references :feed, null: false, index: true
      t.string :entry_id, null: false, index: true
      t.string :title, null: false
      t.string :url, null: false
      t.datetime :reported_at

      t.timestamps
    end
  end
end
