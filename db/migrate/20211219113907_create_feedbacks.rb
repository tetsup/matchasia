class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.references :lesson
      t.text :content

      t.timestamps
    end
  end
end
