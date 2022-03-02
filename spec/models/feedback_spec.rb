require 'rails_helper'

RSpec.describe Feedback, type: :model do
  before do
    zoom_mock
  end

  it 'generates associated data from a factory' do
    travel_to 2.hours.ago
    reservation = FactoryBot.create(:reservation)
    travel_back
    FactoryBot.create(:feedback, lesson: reservation.lesson)
  end

  it 'is invalid with empty content' do
    travel_to 2.hours.ago
    reservation = FactoryBot.create(:reservation)
    travel_back
    feedback = FactoryBot.build(:feedback, lesson: reservation.lesson, content: '')
    feedback.valid?
    expect(feedback.errors[:content]).to include("can't be blank")
  end

  it 'is invalid with lesson not reserved' do
    travel_to 2.hours.ago
    feedback = FactoryBot.build(:feedback)
    travel_back
    feedback.valid?
    expect(feedback.errors[:lesson]).to include('予約されていないレッスンにはフィードバックできません')
  end

  it 'is invalid with lesson not finished' do
    reservation = FactoryBot.create(:reservation)
    feedback = FactoryBot.build(:feedback, lesson: reservation.lesson)
    feedback.valid?
    expect(feedback.errors[:lesson]).to include('終了していないレッスンにはフィードバックできません')
  end
end
