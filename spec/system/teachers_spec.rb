require 'rails_helper'

RSpec.feature 'Teachers', type: :system do
  it 'creates a new lesson as teacher' do
    teacher = FactoryBot.create(:teacher)
    sign_in_as_teacher teacher
    expect {
      click_link 'レッスン管理'
      click_link '新規作成'
      select '2022', from: '開始日時'
      select '中国語', from: '言語'
      click_button '送信'

      expect(page).to have_content '正常に作成できました'
      expect(page).to have_content '中国語'
    }.to change(teacher.lessons, :count).by(1)
  end
end
