require 'rails_helper'

RSpec.feature 'Teachers', type: :system do
  it 'creates a new lesson as teacher' do
    teacher = FactoryBot.create(:teacher)
    sign_in_as_teacher teacher
    expect {
      click_link 'レッスン管理'
      click_link '新規作成'
      lesson_start_time = 1.hours.from_now
      select lesson_start_time.year, from: 'lesson_start_time_1i'
      select lesson_start_time.month, from: 'lesson_start_time_2i'
      select lesson_start_time.day, from: 'lesson_start_time_3i'
      select format('%02<hour>d', hour: lesson_start_time.hour), from: 'lesson_start_time_4i'
      select '中国語', from: '言語'
      click_button '送信'

      expect(page).to have_content '正常に作成できました'
      expect(page).to have_content '中国語'
    }.to change(teacher.lessons, :count).by(1)
  end

  it 'add a photo into profile as teacher' do
    teacher = FactoryBot.create(:teacher)
    sign_in_as_teacher teacher
    click_link 'プロフィール編集'
    fill_in 'Current password', with: teacher.password
    attach_file 'photo', "#{Rails.root}/spec/files/sample.jpg"
    click_button 'Update'
    expect(page).to have_content 'Your account has been updated successfully.'
    visit teacher_path(teacher.id)
    expect(page).to have_selector "img[alt$='photo']"
  end

  it 'adds a feedback into lesson as teacher' do
    travel_to 2.hours.ago
    reservation = FactoryBot.create(:reservation)
    travel_back
    teacher = reservation.lesson.teacher
    feedback_content = '良かったです。'
    expect {
      sign_in_as_teacher teacher
      click_link 'レッスン管理'
      find('td.lesson_feedback').find_link('作成').click
      fill_in 'フィードバックコメント', with: feedback_content
      click_button '送信'
      expect(page).to have_content 'フィードバックを保存しました'
      expect(find('td.lesson_feedback')).to have_content '編集'
    }.to change(teacher.feedbacks, :count).by(1)
    sign_out_teacher
    student = reservation.student
    sign_in_as_student student
    click_link 'レッスン一覧、予約'
    click_link '予約一覧'
    find('td.lesson_feedback').find_link('確認').click
    expect(page).to have_content feedback_content
  end

  it 'adds a report into lesson as teacher' do
    travel_to 2.hours.ago
    reservation = FactoryBot.create(:reservation)
    travel_back
    teacher = reservation.lesson.teacher
    report_content = '○○について指導し、習得しました'
    expect {
      sign_in_as_teacher teacher
      click_link 'レッスン管理'
      find('td.lesson_report').find_link('作成').click
      fill_in '講義内容', with: report_content
      click_button '送信'
      expect(page).to have_content 'レポートを保存しました'
      expect(find('td.lesson_report')).to have_content '編集'
    }.to change(teacher.reports, :count).by(1)
    sign_out_teacher
    another_teacher = FactoryBot.create(:teacher, :another_one)
    sign_in_as_teacher another_teacher
    visit teachers_student_path(reservation.student)
    expect(page).to have_content report_content
  end
end
