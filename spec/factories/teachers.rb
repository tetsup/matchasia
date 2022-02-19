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
  end
end
