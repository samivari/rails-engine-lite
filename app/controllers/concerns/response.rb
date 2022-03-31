module Response
  def json_response(object, status = :ok)
    if object.instance_of?(Hash)
      render json: { error: object[:error] }.to_json, status: 404
    elsif object.errors.present?
      render json: object.errors.messages.to_json, status: 404
    elsif object.instance_of?(Item)
      render json: ItemSerializer.new(object), status: status
    elsif object.instance_of?(Merchant)
      render json: MerchantSerializer.new(object), status: status
    end
  end
end
