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
end

RSpec.configure do |config|
  config.include LoginSupport
end
