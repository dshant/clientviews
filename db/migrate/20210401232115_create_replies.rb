class CreateReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :replies, id: :uuid do |t|
      t.string :from
      t.text :message
      t.string :video_response
      t.string :source
      t.references :response, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
