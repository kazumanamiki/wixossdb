module CardsHelper
	def format_table_data(data)
		return "—" if data.blank?
		return data
	end

	def format_illustrator(illustrator)
		return "" if illustrator.blank?
		return "Illust　" + illustrator
	end

	def format_lb_for_deck(life_burst)
		return "0" if life_burst.blank?
		return "1"
	end

	def format_g_for_deck(guard)
		return "0" if guard.blank?
		return "1"
	end

	def color_string(color)
		case color
		when "赤"
			return "#ECA5B2"
		when "青"
			return "#58B6D2"
		when "緑"
			return "#387948"
		when "白"
			return "#FFF5EE"
		when "黒"
			return "#767676"
		when "無"
			return "#FFFFFF"
		else
			return "#FFFFFF"
		end
	end

	def color_image_file(color)
		case color
		when "赤"
			return "i_red.png"
		when "青"
			return "i_blue.png"
		when "緑"
			return "i_green.png"
		when "白"
			return "i_white.png"
		when "黒"
			return "i_black.png"
		when "無"
			return "i_null.png"
		else
			return ""
		end
	end
end
