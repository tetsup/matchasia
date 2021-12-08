require 'rails_helper'

RSpec.describe Lesson, type: :model do
  it 'generates associated data from a factory' do
    FactoryBot.create(:lesson)
  end

  it 'is invalid without a language' do
    lesson = FactoryBot.build(:lesson, language: nil)
    lesson.valid?
    expect(lesson.errors[:language]).to include("can't be blank")
  end

  it 'is invalid with a past start_time' do
    lesson = FactoryBot.build(:lesson, :started_last_hour)
    lesson.valid?
    expect(lesson.errors[:start_time]).to include('は現在より後の時刻を指定してください')
  end

  it 'is invalid with a duplicated teacher and start_time' do
    same_time = 1.hour.from_now.ceil_to(1.hours)
    specific_teacher = FactoryBot.create(:teacher)
    FactoryBot.create(:lesson, teacher: specific_teacher, start_time: same_time)
    lesson = FactoryBot.build(:lesson, teacher: specific_teacher, start_time: same_time)
    lesson.valid?
    expect(lesson.errors[:start_time]).to include('has already been taken')
  end
end
