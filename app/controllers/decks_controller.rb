class DecksController < ApplicationController

	before_action :signed_in_user, only: [:create, :update, :destroy]
	before_action :correct_user, only: [:update, :destroy]

	def create
		@deck = current_user.decks.build(deck_params)
		@save_flag = @deck.save
	end

	def show
		@deck = Deck.where(id: params[:id]).first
	end

	def update
		if @user_correct_flag
			@deck.card_data = JSON.dump(params[:deck][:card_data])
			@save_flag = @deck.save
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
			params.require(:deck).permit(:name, :card_data)
		end

		def correct_user
			@deck = Deck.where(id: params[:id]).first
			@user_correct_flag = @deck ? (@deck.user_id == current_user.id) : false
		end
end