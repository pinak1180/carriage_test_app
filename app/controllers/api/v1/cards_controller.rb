class Api::V1::CardsController < Api::V1::BaseController
  before_action :authenticate_user_with_authentication_token
  before_action :set_card, :set_card_policy, except: [:create, :index]
  before_action :validate_list, only: [:create]

  def create
    card = @current_user.cards.build(card_params)
    return render_json_un_authorization unless CardAccessManager.new(object: card, user: @current_user).create?
    if card.save
      render_json_object(object: card)
    else
      render_json_object_error(card)
    end
  end

  def update
    return render_json_un_authorization unless @card_policy.update?
    if @card.update(card_params)
      render_json_object(object: @card)
    else
      render_json_object_error(@card)
    end
  end

  def destroy
    return render_json_un_authorization unless @card_policy.delete?
    if @card.destroy
      render_json_message('Card Deleted Successfully')
    else
      render_json_message('Count not delete the Card Please try again')
    end
  end

  def show
    return render_json_un_authorization unless @card_policy.show?
    render_json_object(object: @card, details: true)
  end

  def index
    @cards = CardAccessManager.new(object: Card.new, user: @current_user).access_scope
    render_json_object(object: @cards, details: true)
  end

  private
  def card_params
    params.require(:card).permit(:title, :description, :list_id)
  end

  def set_card
    if @current_user.admin?
      @card = Card.find(params[:id])
    else
      @card = @current_user.cards.find(params[:id])
    end
    bad_record unless @card.present?
  end

  def validate_list
    list_id = params[:card][:list_id]
    if list_id.nil?
      render_json_message('Invalid/ Missing list_id')
    end
  end

  def set_card_policy
    @card_policy = CardAccessManager.new(object: @card, user: @current_user)
  end
end
