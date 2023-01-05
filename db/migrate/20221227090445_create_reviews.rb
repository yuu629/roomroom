class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :review
      t.bigint :stars, default: 1
      t.references :room, null: false, foreign_key: true
      t.references :reservation, null: false, foreign_key: true
      t.references :guest, foreign_key: { to_table: :users }
      t.references :host, foreign_key: { to_table: :users }
      t.string :type

      t.timestamps
    end
  end
end
