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
  end
end
