class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    json_response(Item.find(params[:id]))
  end

  def update
    json_response(Item.update(params[:id], item_params))
  end

  def create
    json_response(Item.create!(item_params), 201)
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
