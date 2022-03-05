require 'rails_helper'

RSpec.describe Report, type: :model do
  before do
    zoom_mock
  end

  xit 'generates associated data from a factory' do
    travel_to 2.hours.ago
    reservation = FactoryBot.create(:reservation)
    travel_back
    FactoryBot.create(:report, lesson: reservation.lesson)
  end

  xit 'is invalid with empty content' do
    travel_to 2.hours.ago
    reservation = FactoryBot.create(:reservation)
    travel_back
    report = FactoryBot.build(:report, lesson: reservation.lesson, content: '')
    report.valid?
    expect(report.errors[:content]).to include("can't be blank")
  end

  it 'is invalid with lesson not reserved' do
    travel_to 2.hours.ago
    report = FactoryBot.build(:report)
    travel_back
    report.valid?
    expect(report.errors[:lesson]).to include('予約されていないレッスンにはレポートを入力できません')
  end

  xit 'is invalid with lesson not finished' do
    reservation = FactoryBot.create(:reservation)
    report = FactoryBot.build(:report, lesson: reservation.lesson)
    report.valid?
    expect(report.errors[:lesson]).to include('終了していないレッスンにはレポートを入力できません')
  end
end
