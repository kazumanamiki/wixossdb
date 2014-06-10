class Deck < ActiveRecord::Base
	belongs_to :user

	validates_length_of :name, { minimum: 1, maximum: 14 }

	def lrig_cards
		search_card_data("lrig_cards")
	end

	def base_cards
		search_card_data("base_cards")
	end

	def lrig_card_id_array
		search_card_id_array("lrig_cards")
	end

	def base_card_id_array
		search_card_id_array("base_cards")
	end

	private
		def search_card_data(deck_name)
			search_cards = JSON.load(self.card_data) if self.card_data
			return search_cards ? search_cards[deck_name] : nil
		end

		def search_card_id_array(deck_name)
			ret = [0]
			search_cards = JSON.load(self.card_data) if self.card_data
			if search_cards && search_cards[deck_name]
				search_cards[deck_name].each do |card_hash|
					ret << card_hash["id"]
				end
			end
			return ret
		end
end
