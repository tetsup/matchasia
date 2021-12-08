FactoryBot.define do
  factory :teacher do
    username { 'aaron' }
    email { 'aaron@example.com' }
    password { 'ajwr;j*ORjio:' }
    about { '自己紹介です\nこれはサンプルです' }
  end
end
