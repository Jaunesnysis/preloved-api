FactoryBot.define do
  factory :transaction do
    item { nil }
    user { nil }
    amount { "9.99" }
    status { "MyString" }
  end
end
