module Api
  module V1
    class ItemsController < BaseController
      def index
        items = SearchItemsService.new(search_params).call
        render_success(items)
      end

      def show
        item = Item.includes(:user, :category).find(params[:id])
        render_success(item)
      rescue ActiveRecord::RecordNotFound
        render_error("Item not found", status: :not_found)
      end

      def create
        item = Item.new(item_params)
        if item.save
          render_success(item, status: :created)
        else
          render_error(item.errors.full_messages)
        end
      end

      def update
        item = Item.find(params[:id])
        if item.update(item_params)
          render_success(item)
        else
          render_error(item.errors.full_messages)
        end
      rescue ActiveRecord::RecordNotFound
        render_error("Item not found", status: :not_found)
      end

      def destroy
        item = Item.find(params[:id])
        item.destroy
        render_success({ message: "Item deleted" })
      rescue ActiveRecord::RecordNotFound
        render_error("Item not found", status: :not_found)
      end

      private

      def search_params
        params.permit(:category_id, :min_price, :max_price, :condition, :query)
      end

      def item_params
        params.require(:item).permit(:title, :description, :price, :condition, :status, :user_id, :category_id)
      end
    end
  end
end