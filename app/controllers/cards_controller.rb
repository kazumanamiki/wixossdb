class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    search_params = {}
    search_params.merge!(original_search_params)
    @cards = Card.search(search_params).result(distinct: true)
    @sq = params.key?(:sq) ? params[:sq] : {}
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  def search
    @cards = Card.where()
    render 'index'
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render action: 'show', status: :created, location: @card }
      else
        format.html { render action: 'new' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:card_number, :name, :name_yomi, :card_rare, :card_kind, :card_type, :card_color, :card_level, :grow_cost, :card_cost, :card_limit, :card_power, :condition, :guard, :card_text, :life_burst, :view_text)
    end

    def original_search_params
      ret = {}
      return ret unless params.key?(:sq)

      if params[:sq].key?(:card_number) && !params[:sq][:card_number].blank?
        ret.merge!({ card_number_cont_any: params[:sq][:card_number].split(' ') })
      end

      if params[:sq].key?(:card_rare) && !params[:sq][:card_rare].blank?
        ret.merge!({ card_rare_in: params[:sq][:card_rare] })
      end

      if params[:sq].key?(:name) && !params[:sq][:name].blank?
        ret.merge!({ name_cont_any: params[:sq][:name].split(' ') }) if params[:sq].key?(:name)
      end

      if params[:sq].key?(:card_kind) && !params[:sq][:card_kind].blank?
        ret.merge!({ card_kind_in: params[:sq][:card_kind] })
      end

      if params[:sq].key?(:card_color) && !params[:sq][:card_color].blank?
        ret.merge!({ card_color_in: params[:sq][:card_color] })
      end

      if params[:sq].key?(:guard) && !params[:sq][:guard].blank?
        if params[:sq][:guard] == "1"
          ret.merge!({ guard_eq: "1" })
        else
          ret.merge!({ guard_not_eq: "1" })
        end
      end

      if params[:sq].key?(:grow_cost) && !params[:sq][:grow_cost].blank?
        ret.merge!({ grow_cost_cont_any: params[:sq][:grow_cost].split(' ') })
      end

      if params[:sq].key?(:card_cost) && !params[:sq][:card_cost].blank?
        ret.merge!({ card_cost_cont_any: params[:sq][:card_cost].split(' ') })
      end

      if params[:sq].key?(:condition) && !params[:sq][:condition].blank?
        ret.merge!({ condition_cont_any: params[:sq][:condition].split(' ') })
      end

      return ret
    end

end
