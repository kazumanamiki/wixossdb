json.array!(@cards) do |card|
  json.extract! card, :id, :card_number, :name, :name_yomi, :card_rare, :card_kind, :card_type, :card_color, :card_level, :grow_cost, :card_cost, :card_limit, :card_power, :condition, :guard, :card_text, :life_burst, :view_text
  json.url card_url(card, format: :json)
end
