FactoryBot.define do
  factory :student do
    username { 'bobby' }
    email { 'bobby@example.com' }
    password { 'PAwprojosrjpyao%oa' }
    tickets { 0 }

    trait :another_one do
      username { 'alice' }
      email { 'alice@example.com' }
    end

    trait :continuous do
      sequence(:username, 'student1')
      sequence(:email) { |i| "student#{i}@example.com" }
      tickets { 1000 }
    end
  end
end
