module Api
  module V1
    class CategoriesController < BaseController
      def index
        categories = Category.all
        render_success(categories)
      end

      def show
        category = Category.find(params[:id])
        render_success(category)
      rescue ActiveRecord::RecordNotFound
        render_error("Category not found", status: :not_found)
      end

      def create
        category = Category.new(category_params)
        if category.save
          render_success(category, status: :created)
        else
          render_error(category.errors.full_messages)
        end
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end