require 'rails_helper'

RSpec.feature 'Students', type: :system do
  it 'buy a new ticket as student', js: true do
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
end
