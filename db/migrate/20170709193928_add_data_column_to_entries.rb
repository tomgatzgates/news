class AddDataColumnToEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :data, :jsonb
  end
end
