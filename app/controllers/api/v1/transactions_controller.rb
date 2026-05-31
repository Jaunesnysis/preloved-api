module Api
  module V1
    class TransactionsController < BaseController
      def index
        transactions = Transaction.includes(:item, :user).all
        render_success(transactions)
      end

      def show
        transaction = Transaction.includes(:item, :user).find(params[:id])
        render_success(transaction)
      rescue ActiveRecord::RecordNotFound
        render_error("Transaction not found", status: :not_found)
      end

      def create
        transaction = PurchaseItemService.new(
          buyer_id: params[:buyer_id],
          item_id: params[:item_id]
        ).call

        render_success(transaction, status: :created)
      rescue ServiceError => e
        render_error(e.message, status: :unprocessable_entity)
      rescue ActiveRecord::RecordNotFound => e
        render_error(e.message, status: :not_found)
      end
    end
  end
end