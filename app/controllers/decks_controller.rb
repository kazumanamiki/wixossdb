class DecksController < ApplicationController

	before_action :signed_in_user, only: [:create, :update, :destroy]
	before_action :correct_user, only: [:update, :destroy]

	def create
		@deck = current_user.decks.build(deck_params)
		@save_flag = @deck.save
	end

	def show
		@deck = Deck.where(id: params[:id]).first
		respond_to do |format|
			format.json { }
			format.html do

				deck_lrig_cards = @deck.lrig_cards
				lrig_card_models = Card.search({ id_in: @deck.lrig_card_id_array }).result(distinct: true)

				deck_base_cards = @deck.base_cards
				base_card_models = Card.search({ id_in: @deck.base_card_id_array }).result(distinct: true)

				@lrig_cards_ahash = create_html_deck_data(deck_lrig_cards, lrig_card_models)
				@base_cards_ahash = create_html_deck_data(deck_base_cards, base_card_models)
			end
		end
	end

	def update
		respond_to do |format|
			# 名前とコメントの変更
			format.js do
				if @user_correct_flag
					@save_flag = @deck.update_attributes(deck_params)
				end
			end
			# デッキカードの変更
			format.json do
				if @user_correct_flag
					@deck.card_data = JSON.dump(params[:deck][:card_data])
					@deck.save
				end
				head :no_content
			end
		end
	end

	def destroy
		if @user_correct_flag
			@deck.destroy
			respond_to do |format|
				format.html { redirect_to decks_url }
				format.js { } #Viewで処理
			end
		end
	end

	private
		def deck_params
			params.require(:deck).permit(:name, :comment)
		end

		def correct_user
			@deck = Deck.where(id: params[:id]).first
			@user_correct_flag = @deck ? (@deck.user_id == current_user.id) : false
		end

		def create_html_deck_data(deck_json_data, card_models)
			# 表示用のハッシュを生成してソートする(ルリグデッキ)
			deck_data_hash = {}
			if deck_json_data
				deck_json_data.each_with_index do |card_hash, index|
					deck_data_hash[card_hash["id"]] = { deck_data: card_hash, card_data: nil, sort_index: index}
				end
				card_models.each do |card_data|
					if deck_data_hash.key?(card_data.id.to_s)
						deck_data_hash[card_data.id.to_s][:card_data] = card_data
					end
				end
			end
			return deck_data_hash.sort_by { |k, v| v[:sort_index] }
		end
end