FactoryBot.define do
  factory :feedback do
    association :lesson, :started_last_hour
    content { 'thanks for last lesson.\nsee you again!' }
  end
end
