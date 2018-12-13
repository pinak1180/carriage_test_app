class CreateAuthenticationTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :authentication_tokens do |t|
      t.references :user, foreign_key: true, index: true
      t.string :token
      t.timestamps
    end
    add_index :authentication_tokens, :token
  end
end
