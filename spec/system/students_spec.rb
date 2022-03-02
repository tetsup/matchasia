require 'rails_helper'

RSpec.feature 'Students', type: :system do
  include ActiveJob::TestHelper
  before do
    zoom_mock
  end

  it 'reserve a new lesson as student' do
    student = FactoryBot.create(:student, tickets: 1)
    lesson = FactoryBot.create(:lesson, language_id: 1)
    perform_enqueued_jobs do
      sign_in_as_student student
      expect {
        visit root_path
        click_link 'レッスン一覧、予約'
        expect(find('table')).to have_content '中国語'
        select '中国語', from: 'lesson_language_id'
        wait_for_change_url { click_button '検索' }
        click_button '予約'
        expect(page).to have_content '予約が完了しました'
      }.to change(student.reservations, :count).by(1)
    end
    mail_to_array = ActionMailer::Base.deliveries.map(&:to)
    expect(mail_to_array).to include [student.email]
    expect(mail_to_array).to include [lesson.teacher.email]
  end

  xit 'buy a new ticket as student', js: true do
    # stripe checkoutに変更したため動作せず、webhook対応も必要なのでmock化する
    student = FactoryBot.create(:student, tickets: 0)
    sign_in_as_student student
    expect {
      click_link 'チケットの確認、購入'
      within '#buy-tickets-3' do
        click_button 'Pay with Card'
      end
      expect(page).to have_selector 'iframe'
      within_frame find('iframe') do
        expect(page).to have_selector '#card_number'
        4.times { page.driver.browser.find_element(:id, 'card_number').send_keys('4242') }
        page.driver.browser.find_element(:id, 'cc-exp').send_keys('04')
        page.driver.browser.find_element(:id, 'cc-exp').send_keys('42')
        fill_in 'cc-csc', with: '442'
        click_button 'submitButton'
      end
      expect(page).to have_content 'チケットを購入しました', wait: 10
    }.to change { student.reload.tickets }.by(3)
  end

  it 'has a trial ticket on registeration as student' do
    username = 'ariel'
    password = 'Awajkwp@::wtat'
    email = 'ariel@example.com'
    visit root_path
    click_link 'サインアップ'
    fill_in 'student_username', with: username
    fill_in 'student_email', with: email
    fill_in 'student_password', with: password
    fill_in 'student_password_confirmation', with: password
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    click_link 'チケットの確認、購入'
    expect(find('span#tickets').text).to eq '1'
  end
end
