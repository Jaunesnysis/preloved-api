class MetricsService
  CACHE_EXPIRY = 1.minute

  def call
    cached = REDIS.get(cache_key)
    if cached
      Rails.logger.info("[MetricsService] Cache HIT")
      return JSON.parse(cached, symbolize_names: true)
    end

    Rails.logger.info("[MetricsService] Cache MISS — computing metrics")
    metrics = compute_metrics
    REDIS.setex(cache_key, CACHE_EXPIRY, metrics.to_json)
    metrics
  end

  private

  def compute_metrics
    {
      users: {
        total: User.count
      },
      items: {
        total: Item.count,
        available: Item.where(status: "available").count,
        sold: Item.where(status: "sold").count
      },
      transactions: {
        total: Transaction.count,
        completed: Transaction.where(status: "completed").count,
        total_volume: Transaction.where(status: "completed").sum(:amount).to_f
      },
      categories: {
        total: Category.count
      },
      generated_at: Time.now.utc.iso8601
    }
  end

  def cache_key
    "metrics:dashboard"
  end
end