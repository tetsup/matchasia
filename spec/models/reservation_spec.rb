require 'rails_helper'

RSpec.describe Reservation, type: :model do
  before do
    zoom_mock
  end

  it 'generates associated data from a factory' do
    FactoryBot.create(:reservation)
  end

  it 'is invalid with lesson that is already started' do
    travel_to 2.hours.ago
    lesson_started = FactoryBot.create(:lesson, :start_one_hour_later)
    travel_back
    reservation = FactoryBot.build(:reservation, lesson: lesson_started)
    reservation.valid?
    expect(reservation.errors[:lesson]).to include('開始時刻を過ぎているレッスンは予約できません')
  end

  it 'is invalid with duplicate lesson' do
    lesson = FactoryBot.create(:lesson)
    student1 = FactoryBot.create(:student)
    student2 = FactoryBot.create(:student, :another_one)
    FactoryBot.create(:reservation, lesson: lesson, student: student1)
    reservation = FactoryBot.build(:reservation, lesson: lesson, student: student2)
    reservation.valid?
    expect(reservation.errors[:lesson]).to include('has already been taken')
  end
end
