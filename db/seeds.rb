puts "Cleaning database..."
Transaction.destroy_all
Item.destroy_all
Category.destroy_all
User.destroy_all

puts "Seeding categories..."
categories = ["Clothing", "Shoes", "Accessories", "Electronics", "Books", "Home & Living", "Sports", "Toys"].map do |name|
  Category.create!(name: name)
end

puts "Seeding users..."
users = [
  { username: "alice_seller", email: "alice@example.com", balance: 500.00 },
  { username: "bob_buyer", email: "bob@example.com", balance: 300.00 },
  { username: "carol_trades", email: "carol@example.com", balance: 750.00 },
  { username: "dave_preloved", email: "dave@example.com", balance: 150.00 }
].map { |attrs| User.create!(attrs) }

puts "Seeding items..."
items_data = [
  { title: "Vintage denim jacket", description: "Classic 90s style, barely worn", price: 35.00, condition: "like_new", category_name: "Clothing" },
  { title: "Nike Air Max 90", description: "Size 42, great condition", price: 55.00, condition: "good", category_name: "Shoes" },
  { title: "Leather handbag", description: "Brown leather, fits everything", price: 40.00, condition: "good", category_name: "Accessories" },
  { title: "iPhone 12 case", description: "Clear case, never used", price: 5.00, condition: "new", category_name: "Electronics" },
  { title: "The Pragmatic Programmer", description: "Essential reading, minor highlights", price: 12.00, condition: "good", category_name: "Books" },
  { title: "Yoga mat", description: "Purple, 6mm thick", price: 18.00, condition: "like_new", category_name: "Sports" },
  { title: "Wool scarf", description: "Warm and soft, winter essential", price: 15.00, condition: "good", category_name: "Clothing" },
  { title: "Running shoes", description: "Asics Gel, size 40", price: 30.00, condition: "fair", category_name: "Shoes" },
  { title: "Coffee table book", description: "Architecture photography", price: 20.00, condition: "like_new", category_name: "Books" },
  { title: "Ceramic plant pot", description: "Set of 3, white matte", price: 22.00, condition: "new", category_name: "Home & Living" }
]

items = items_data.map do |attrs|
  category = categories.find { |c| c.name == attrs[:category_name] }
  seller = users.sample
  Item.create!(
    title: attrs[:title],
    description: attrs[:description],
    price: attrs[:price],
    condition: attrs[:condition],
    user: seller,
    category: category,
    status: "available"
  )
end

puts "Seeding transactions..."
buyer = users[1]
item = items[0]
item.update!(status: "sold")
buyer.update!(balance: buyer.balance - item.price)
Transaction.create!(item: item, user: buyer, amount: item.price, status: "completed")

puts "Done! Seeded #{User.count} users, #{Category.count} categories, #{Item.count} items, #{Transaction.count} transactions."