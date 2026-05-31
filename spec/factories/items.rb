FactoryBot.define do
  factory :item do
    title { "MyString" }
    description { "MyText" }
    price { "9.99" }
    condition { "MyString" }
    status { "MyString" }
    user { nil }
    category { nil }
  end
end
