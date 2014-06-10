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
				@rlig_cards = Card.search({ id_in: @deck.lrig_card_id_array }).result(distinct: true).order(:card_level, :card_power)
				@base_cards = Card.search({ id_in: @deck.base_card_id_array }).result(distinct: true).order(:card_level, :card_power)
				@deck.lrig_card_id_array
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
end