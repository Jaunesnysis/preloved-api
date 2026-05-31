module Api
  module V1
    class MetricsController < BaseController
      def index
        metrics = MetricsService.new.call
        render_success(metrics)
      end
    end
  end
end