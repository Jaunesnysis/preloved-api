class PurchaseItemService
  def initialize(buyer_id:, item_id:)
    @buyer = User.find(buyer_id)
    @item = Item.find(item_id)
  end

  def call
    validate!

    ActiveRecord::Base.transaction do
      @buyer.update!(balance: @buyer.balance - @item.price)
      @item.update!(status: "sold")

      Transaction.create!(
        item: @item,
        user: @buyer,
        amount: @item.price,
        status: "completed"
      )
    end
  rescue ActiveRecord::RecordNotFound => e
    raise ServiceError, e.message
  end

  private

  def validate!
    raise ServiceError, "Item is not available" unless @item.status == "available"
    raise ServiceError, "Insufficient balance" if @buyer.balance < @item.price
    raise ServiceError, "Buyer cannot purchase their own item" if @item.user_id == @buyer.id
  end
end