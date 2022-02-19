class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :lesson
      t.text :content

      t.timestamps
    end
  end
end
