# preloved-api

A RESTful marketplace API built with Ruby on Rails, inspired by how platforms like Vinted handle second-hand item listings, purchases, and search.

## Tech Stack

- **Ruby 3.3.0 / Rails 7.1**
- **PostgreSQL** — primary database with foreign key constraints and unique indexes
- **Redis** — caching for search results and metrics (5 min and 1 min TTL respectively)
- **Lograge** — structured JSON request logging
- **RSpec + FactoryBot** — test setup

## Domain Model

User → sells Items, makes Transactions (as buyer)
Item → belongs to User (seller) and Category
Transaction → records a completed purchase between buyer and Item

## Key Design Decisions

**Atomic transactions** — purchases use `ActiveRecord::Base.transaction` to ensure balance deduction, item status update, and transaction record creation all succeed or all roll back.

**Service objects** — business logic lives in `app/services/`, not controllers. `PurchaseItemService` handles validation and the purchase flow. `SearchItemsService` handles filtering and caching.

**Redis caching** — search results are cached per unique filter combination. Metrics are cached separately with a shorter TTL since they aggregate across the whole dataset.

**Versioned API** — all endpoints live under `/api/v1/` for forward compatibility.

**Guard rails on purchases:**

- Item must be `available`
- Buyer must have sufficient balance
- Buyer cannot purchase their own item

## Getting Started

### Prerequisites

- Ruby 3.3.0
- PostgreSQL
- Redis

### Setup

```bash
git clone https://github.com/YOURUSERNAME/preloved-api.git
cd preloved-api
bundle install
cp .env.example .env        # fill in your DB credentials
rails db:create db:migrate db:seed
rails server
```

## API Endpoints

### Users

| Method | Path                | Description    |
| ------ | ------------------- | -------------- |
| GET    | `/api/v1/users`     | List all users |
| GET    | `/api/v1/users/:id` | Get a user     |
| POST   | `/api/v1/users`     | Create a user  |

### Categories

| Method | Path                     | Description         |
| ------ | ------------------------ | ------------------- |
| GET    | `/api/v1/categories`     | List all categories |
| GET    | `/api/v1/categories/:id` | Get a category      |
| POST   | `/api/v1/categories`     | Create a category   |

### Items

| Method | Path                | Description                            |
| ------ | ------------------- | -------------------------------------- |
| GET    | `/api/v1/items`     | List available items (supports search) |
| GET    | `/api/v1/items/:id` | Get an item                            |
| POST   | `/api/v1/items`     | Create a listing                       |
| PATCH  | `/api/v1/items/:id` | Update a listing                       |
| DELETE | `/api/v1/items/:id` | Delete a listing                       |

**Search parameters:**

- `query` — title keyword search
- `category_id` — filter by category
- `condition` — one of: `new`, `like_new`, `good`, `fair`, `poor`
- `min_price` / `max_price` — price range

### Transactions

| Method | Path                       | Description           |
| ------ | -------------------------- | --------------------- |
| GET    | `/api/v1/transactions`     | List all transactions |
| GET    | `/api/v1/transactions/:id` | Get a transaction     |
| POST   | `/api/v1/transactions`     | Purchase an item      |

**Purchase request body:**

```json
{
  "buyer_id": 2,
  "item_id": 1
}
```

### Metrics

| Method | Path              | Description                      |
| ------ | ----------------- | -------------------------------- |
| GET    | `/api/v1/metrics` | Marketplace stats (cached 1 min) |

**Example response:**

```json
{
  "users": { "total": 4 },
  "items": { "total": 10, "available": 9, "sold": 1 },
  "transactions": { "total": 1, "completed": 1, "total_volume": 35.0 },
  "categories": { "total": 8 },
  "generated_at": "2026-05-31T18:00:00Z"
}
```

## Architecture

app/
├── controllers/api/v1/ # Thin controllers, delegate to services
├── models/ # AR models with validations and associations
└── services/
├── purchase_item_service.rb # Atomic purchase flow
├── search_items_service.rb # Filtered search with Redis cache
└── metrics_service.rb # Marketplace stats with Redis cache

## Auth

Authentication is intentionally out of scope for this version. In production this would use JWT tokens with a middleware layer applied to all write endpoints.
