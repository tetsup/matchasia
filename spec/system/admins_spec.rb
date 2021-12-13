require 'rails_helper'

RSpec.feature 'Admins', type: :system do
  include ActiveJob::TestHelper
  it 'creates a new teacher as admin' do
    admin = FactoryBot.create(:admin)
    teacher_username = 'TestTeacher'
    teacher_email = 'test_teacher@example.com'
    perform_enqueued_jobs do
      sign_in_as_admin admin
      expect {
        click_link '講師管理'
        click_link '講師新規作成'
        fill_in 'Username', with: teacher_username
        fill_in 'Email', with: teacher_email
        click_button 'Sign up'
        expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
      }.to change(Teacher, :count).by(1)
    end
    confirmation_mail = ActionMailer::Base.deliveries.last
    expect(confirmation_mail.to).to eq [teacher_email]
  end
end
