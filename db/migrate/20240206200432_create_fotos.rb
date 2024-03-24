class CreateFotos < ActiveRecord::Migration[7.1]
  def change
    create_table :fotos do |t|
      t.integer :ordem
      t.string :imagem

      t.timestamps
    end
  end
end
