class CreateVisitorIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :visitor_identities, id: :uuid do |t|
      t.string :visitor_token
      t.string :uid
      t.string :email
      t.jsonb :extra_attributes, null: false, default: {}
      t.jsonb :account, null: false, default: {}

      t.timestamps
    end

    add_index  :visitor_identities, :extra_attributes, using: :gin
    add_index  :visitor_identities, :account, using: :gin
  end
end
