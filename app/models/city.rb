class City < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	#validates :nome, presence: true, uniqueness: {scope: :empresa_id}
end
