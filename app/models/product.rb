class Product < ApplicationRecord
  belongs_to :user
  belongs_to :bland
  belongs_to :condition
  belongs_to :category
  has_many :images  , dependent: :destroy
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :images

end
