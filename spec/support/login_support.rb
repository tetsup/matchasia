module LoginSupport
  def sign_in_as_teacher(teacher)
    visit root_path
    click_link '講師ログイン'
    fill_in 'Email', with: teacher.email
    fill_in 'Password', with: teacher.password
    click_button 'Log in'
  end

  def sign_in_as_student(student)
    visit root_path
    click_link 'ログイン'
    fill_in 'Email', with: student.email
    fill_in 'Password', with: student.password
    click_button 'Log in'
  end

  def sign_in_as_admin(admin)
    visit root_path
    click_link '管理者ログイン'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Log in'
  end

  def sign_out_teacher
    visit root_path
    click_button '講師ログアウト'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
