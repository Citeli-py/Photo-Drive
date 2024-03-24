class Foto < ApplicationRecord
  validates :imagem, presence: true
end
