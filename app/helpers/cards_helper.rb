module CardsHelper
	def format_table_data(data)
		return "—" if data.blank?
		return data
	end
end
