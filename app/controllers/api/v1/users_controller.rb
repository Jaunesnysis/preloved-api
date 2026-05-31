module Api
  module V1
    class UsersController < BaseController
      def index
        users = User.all
        render_success(users)
      end

      def show
        user = User.find(params[:id])
        render_success(user)
      rescue ActiveRecord::RecordNotFound
        render_error("User not found", status: :not_found)
      end

      def create
        user = User.new(user_params)
        if user.save
          render_success(user, status: :created)
        else
          render_error(user.errors.full_messages)
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :balance)
      end
    end
  end
end