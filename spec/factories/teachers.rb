FactoryBot.define do
  factory :teacher do
    username { 'aaron' }
    email { 'aaron@example.com' }
    confirmed_at { Time.now }
    password { 'ajwr;j*ORjio:' }
    about { '自己紹介です\nこれはサンプルです' }

    trait :another_one do
      username { 'sven' }
      email { 'sven@example.com' }
    end

    trait :continuous do
      sequence(:username, 'teacher1')
      sequence(:email) { |i| "teacher#{i}@example.com" }
      sequence(:language, 0) { |i| Language.find(i % 5 + 1) }
    end
  end
end
