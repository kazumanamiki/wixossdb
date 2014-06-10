if @deck.nil?
	json.status 400
else
	json.status 200
	json.id(@deck.id)
	json.name(@deck.name)
	json.comment(@deck.comment)
	json.set! :deck_lrig do
		json.array!(@deck.lrig_cards) do |card|
			json.id card["id"]
			json.name card["name"]
			json.count card["count"]
			json.lb card["lb"]
			json.g card["g"]
		end
	end
	json.set! :deck_base do
		json.array!(@deck.base_cards) do |card|
			json.id card["id"]
			json.name card["name"]
			json.count card["count"]
			json.lb card["lb"]
			json.g card["g"]
		end
	end
end