class SearchItemsService
  CACHE_EXPIRY = 5.minutes

  def initialize(params)
    @category_id = params[:category_id]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @condition = params[:condition]
    @query = params[:query]
  end

  def call
    cached_results || fresh_results
  end

  private

  def cached_results
    cached = REDIS.get(cache_key)
    return nil unless cached

    Rails.logger.info("[SearchItemsService] Cache HIT for key: #{cache_key}")
    JSON.parse(cached)
  end

  def fresh_results
    Rails.logger.info("[SearchItemsService] Cache MISS for key: #{cache_key}")
    items = Item.includes(:user, :category).where(status: "available")
    items = items.where(category_id: @category_id) if @category_id.present?
    items = items.where("price >= ?", @min_price) if @min_price.present?
    items = items.where("price <= ?", @max_price) if @max_price.present?
    items = items.where(condition: @condition) if @condition.present?
    items = items.where("title ILIKE ?", "%#{@query}%") if @query.present?

    result = items.as_json
    REDIS.setex(cache_key, CACHE_EXPIRY, result.to_json)
    result
  end

  def cache_key
    "items:search:#{[@category_id, @min_price, @max_price, @condition, @query].join(':')}"
  end
end