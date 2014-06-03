module PriceAnalyzeHelper
	require "open-uri"
	require "nokogiri"

	module HtmlAnalyze

		def parse(url)
			io = URI.parse(url).read
			charset = io.scan(/charset="?([^\s"]*)/i).flatten.inject(Hash.new{0}){|a, b|
				a[b]+=1
				a
			}.to_a.sort_by{|a|
				a[1]
			}.reverse.first[0]
			Nokogiri(io, url, charset)
		end

		# CSS指定要素配下のテキストを抽出する
		# @param [Nokogiri::XML::Document] doc
		# @param [String] css_string CSS文字列
		# @return [Array<String>] テキストの配列
		def pure_texts_css(doc, css_string)
			ret_array = []
			doc.css(css_string).each do |search_element|
				text = ""
				search_element.children.each do |children_element|
					text << pure_text_element(children_element)
				end
				ret_array.push text
			end
			return ret_array
		end

		# CSS指定要素配下の指定属性を抽出する
		# @param [Nokogiri::XML::Document] doc
		# @param [String] css_string CSS文字列
		# @param [String] attribute 取得する属性
		# @return [Array<String>] ピュアテキストの配列
		def attributes_css(doc, css_string, attribute)
			ret_array = []
			doc.css(css_string).each do |search_element|
				ret_array.push search_element[attribute]
			end
			return ret_array
		end

		# @param [Nokogiri::XML::Element] element 抽出対象のelement
		# @return [String] ピュアテキスト(なければ空文字)
		def pure_text_element(element)
			case element
			when Nokogiri::XML::Text
				return element.text.strip
			else
				return ""
			end
		end
	end

	class YahooAuctions
		include HtmlAnalyze

		def extract_datas(keyword_array)
			doc = parse(create_search_url(keyword_array))

			# 解析
			paths  = attributes_css(doc, "div#list01 div.a1wrp > h3 > a", "href")
			names  = pure_texts_css(doc, "div#list01 div.a1wrp > h3 > a")
			prices = pure_texts_css(doc, "div#list01 td.pr1")

			# ハッシュ化
			ret_hash_array = []
			paths.zip(names, prices) { |arr| ret_hash_array.push({ path: arr[0], name: arr[1], price: arr[2] }) }

			# データ加工
			ret_hash_array.each do |ret_hash|
				ret_hash[:price].gsub!(",", "")
				ret_hash[:price].gsub!("円", "")
			end

			return ret_hash_array
		end

		private
			def create_search_url(keyword_array)
				search_text = URI.encode(keyword_array.join("+"))
				sprintf("http://auctions.search.yahoo.co.jp/search?p=%s&select=01", search_text)
			end
	end
end
