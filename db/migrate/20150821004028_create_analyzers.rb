class CreateAnalyzers < ActiveRecord::Migration
  def change
    create_table :analyzers do |t|

      t.timestamps null: false
    end
  end
end
