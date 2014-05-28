class Card < ActiveRecord::Base
	default_scope -> { order('card_number ASC') }

	before_save :create_search_all_text

	private
		def create_search_all_text
			self. search_all_text = self.attribute_names.inject("") do |sum, attribute|
				sum << self[attribute].to_s unless self[attribute].nil?
				sum
			end
		end
end
