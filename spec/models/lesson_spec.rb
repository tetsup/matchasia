require 'rails_helper'

RSpec.describe Lesson, type: :model do
  before do
    zoom_mock
  end

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

  describe 'count methods' do
    before do
      travel_to Time.new(2021, 12, 29)
      @teachers = FactoryBot.create_list(:teacher, 3, :continuous)
      students = FactoryBot.create_list(:student, 3, :continuous)
      lessons = [
        FactoryBot.create(:lesson, teacher: @teachers[0], start_time: Time.new(2021, 12, 30, 7), language_id: 1),
        FactoryBot.create(:lesson, teacher: @teachers[1], start_time: Time.new(2021, 12, 30, 7), language_id: 2),
        FactoryBot.create(:lesson, teacher: @teachers[2], start_time: Time.new(2021, 12, 30, 7), language_id: 3),
        FactoryBot.create(:lesson, teacher: @teachers[1], start_time: Time.new(2021, 12, 30, 13), language_id: 1),
        FactoryBot.create(:lesson, teacher: @teachers[2], start_time: Time.new(2021, 12, 30, 13), language_id: 2),
        FactoryBot.create(:lesson, teacher: @teachers[2], start_time: Time.new(2021, 12, 30, 22), language_id: 1),
        FactoryBot.create(:lesson, teacher: @teachers[0], start_time: Time.new(2022, 1, 1, 22), language_id: 3)
      ]
      reservations = [
        FactoryBot.create(:reservation, :continuous, lesson: lessons[0], student: students[0]),
        FactoryBot.create(:reservation, :continuous, lesson: lessons[1], student: students[1]),
        FactoryBot.create(:reservation, :continuous, lesson: lessons[4], student: students[2]),
        FactoryBot.create(:reservation, :continuous, lesson: lessons[6], student: students[0])
      ]
      travel_back
    end

    it 'counts lessons by date and time' do
      count_data = Lesson.count_by_date_and_time(Date.new(2021, 12, 30), Date.new(2022, 1, 1))
      expect(count_data[[Date.new(2021, 12, 30), 7]]).to eq 3
      expect(count_data[[Date.new(2021, 12, 30), 13]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 30), 22]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), 8]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1), 22]]).to eq 1
    end

    it 'not counts lessons out of date range' do
      count_data = Lesson.count_by_date_and_time(Date.new(2021, 12, 28), Date.new(2021, 12, 29))
      expect(count_data[[Date.new(2021, 12, 30), 7]]).to eq nil
      count_data = Lesson.count_by_date_and_time(Date.new(2022, 1, 2), Date.new(2022, 1, 5))
      expect(count_data[[Date.new(2022, 1, 1), 22]]).to eq nil
    end

    it 'counts reservations by date and time' do
      count_data = Lesson.reserved_count_by_date_and_time(Date.new(2021, 12, 30), Date.new(2022, 1, 1))
      expect(count_data[[Date.new(2021, 12, 30), 7]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 30), 13]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), 22]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1), 22]]).to eq 1
    end

    it 'not counts reservations out of date range' do
      count_data = Lesson.reserved_count_by_date_and_time(Date.new(2021, 12, 28), Date.new(2021, 12, 29))
      expect(count_data[[Date.new(2021, 12, 30), 7]]).to eq nil
      count_data = Lesson.reserved_count_by_date_and_time(Date.new(2022, 1, 2), Date.new(2022, 1, 5))
      expect(count_data[[Date.new(2022, 1, 1), 22]]).to eq nil
    end

    it 'counts lessons by language and month' do
      count_data = Lesson.count_by_month_and_language
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, 1]]).to eq 3
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, 2]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, 3]]).to eq 1
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, 1]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, 2]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, 3]]).to eq 1
    end

    it 'counts reservations by language and month' do
      count_data = Lesson.reserved_count_by_month_and_language
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, 1]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, 2]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, 3]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, 1]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, 2]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, 3]]).to eq 1
    end

    it 'counts lessons by teacher and month' do
      count_data = Lesson.count_by_month_and_teacher
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, @teachers[1].id]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, @teachers[2].id]]).to eq 3
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, @teachers[1].id]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, @teachers[2].id]]).to eq nil
    end

    it 'counts reservations by teacher and month' do
      count_data = Lesson.reserved_count_by_month_and_teacher
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, @teachers[1].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 1) + 9.hours, @teachers[2].id]]).to eq 1
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, @teachers[1].id]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1) + 9.hours, @teachers[2].id]]).to eq nil
    end

    it 'counts lessons by language and date' do
      count_data = Lesson.count_by_date_and_language(Date.new(2021, 12, 1), Date.new(2021, 12, 31))
      expect(count_data[[Date.new(2021, 12, 30), 1]]).to eq 3
      expect(count_data[[Date.new(2021, 12, 30), 2]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 30), 3]]).to eq 1
      expect(count_data[[Date.new(2022, 1, 1), 3]]).to eq nil
      count_data = Lesson.count_by_date_and_language(Date.new(2022, 1, 1), Date.new(2022, 1, 31))
      expect(count_data[[Date.new(2022, 1, 1), 3]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), 1]]).to eq nil
    end

    it 'counts reservations by language and date' do
      count_data = Lesson.reserved_count_by_date_and_language(Date.new(2021, 12, 1), Date.new(2021, 12, 31))
      expect(count_data[[Date.new(2021, 12, 30), 1]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), 2]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 30), 3]]).to eq nil
      expect(count_data[[Date.new(2022, 1, 1), 3]]).to eq nil
      count_data = Lesson.reserved_count_by_date_and_language(Date.new(2022, 1, 1), Date.new(2022, 1, 31))
      expect(count_data[[Date.new(2022, 1, 1), 3]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), 1]]).to eq nil
    end

    it 'counts lessons by teacher and date' do
      count_data = Lesson.count_by_date_and_teacher(Date.new(2021, 12, 1), Date.new(2021, 12, 31))
      expect(count_data[[Date.new(2021, 12, 30), @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), @teachers[1].id]]).to eq 2
      expect(count_data[[Date.new(2021, 12, 30), @teachers[2].id]]).to eq 3
      expect(count_data[[Date.new(2022, 1, 1), @teachers[0].id]]).to eq nil
      count_data = Lesson.count_by_date_and_teacher(Date.new(2022, 1, 1), Date.new(2022, 1, 31))
      expect(count_data[[Date.new(2022, 1, 1), @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), @teachers[0].id]]).to eq nil
    end

    it 'counts reservations by teacher and date' do
      count_data = Lesson.reserved_count_by_date_and_teacher(Date.new(2021, 12, 1), Date.new(2021, 12, 31))
      expect(count_data[[Date.new(2021, 12, 30), @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), @teachers[1].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), @teachers[2].id]]).to eq 1
      expect(count_data[[Date.new(2022, 1, 1), @teachers[0].id]]).to eq nil
      count_data = Lesson.reserved_count_by_date_and_teacher(Date.new(2022, 1, 1), Date.new(2022, 1, 31))
      expect(count_data[[Date.new(2022, 1, 1), @teachers[0].id]]).to eq 1
      expect(count_data[[Date.new(2021, 12, 30), @teachers[0].id]]).to eq nil
    end
  end
end
