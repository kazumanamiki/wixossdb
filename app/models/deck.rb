class Deck < ActiveRecord::Base
	validates_length_of :name, { minimum: 1, maximum: 14 }

	def lrig_cards
		search_card_data("lrig_cards")
	end

	def base_cards
		search_card_data("base_cards")
	end

	private
		def search_card_data(deck_name)
			search_cards = JSON.load(self.card_data) if self.card_data
			return search_cards ? search_cards[deck_name] : nil
		end
end
