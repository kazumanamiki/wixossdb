module CardsHelper
	def format_table_data(data)
		return "—" if data.blank?
		return data
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
