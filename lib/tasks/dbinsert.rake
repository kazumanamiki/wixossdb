namespace :wixoss do
	desc "insert json file"
	task insert: :environment do
		data_array = read_json_file("./lib/tasks/card_data.json")
		data_array.each do |data|
			if valid_data?(data)
				## TODO 今後の為にfirst_or_createにして既に存在しているものをは作らないようにするべき？
				# Card.where(card_number: make_data["card_number"]).first_or_create do |card|
				# end
				Card.create(make_model_hash(data))
			end
		end
	end

	def read_json_file(file_path)
		data_array = nil
		File.open(file_path) do |io|
			data_array = JSON.load(io)
		end
		data_array
	end

	def valid_data?(data)
		return false if data["card_number"].blank?
		return false if data["name"].blank?
		return true
	end

	def make_model_hash(data)
		ret = {}
		ret.merge!(data)

		ret["card_kind"] = nil if data["card_kind"] == "-"
		ret["card_type"] = nil if data["card_type"] == "-"
		ret["card_color"] = nil if data["card_color"] == "-"
		ret["card_level"] = nil if data["card_level"] == "-"
		ret["grow_cost"] = nil if data["grow_cost"] == "-"
		ret["card_cost"] = nil if data["card_cost"] == "-"
		ret["card_limit"] = nil if data["card_limit"] == "-"
		ret["grow_cost"] = nil if data["grow_cost"] == "-"
		ret["card_power"] = nil if data["card_power"] == "-"
		ret["condition"] = nil if data["condition"] == "-"
		ret["guard"] = nil if data["guard"] == "-"

		ret["card_text"] = make_card_text(data["card_text"])
		ret["life_burst"] = make_card_text(data["life_burst"])
		ret["view_text"] = make_card_text(data["view_text"])
		ret
	end

	def make_card_text(text_array)
		return nil if text_array.blank?
		text_array.inject("") do |sum, text_hash|
			sum << text_hash["type"] unless text_hash["type"].blank?
			sum << text_hash["cost"] unless text_hash["cost"].blank?
			sum << text_hash["text"] << "||"
			sum
		end
	end
end
