require 'rails_helper'

RSpec.describe Teacher, type: :model do
  before do
    zoom_mock
  end

  it 'is valid with a username, email, and password' do
    teacher = FactoryBot.build(:teacher)
    expect(teacher).to be_valid
  end

  it 'is invalid without a username' do
    teacher = FactoryBot.build(:teacher, username: nil)
    teacher.valid?
    expect(teacher.errors[:username]).to include("can't be blank")
  end

  it 'is invalid without an email address' do
    teacher = FactoryBot.build(:teacher, email: nil)
    teacher.valid?
    expect(teacher.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password' do
    teacher = FactoryBot.build(:teacher, password: nil)
    teacher.valid?
    expect(teacher.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:teacher, email: 'aaron@example.com')
    teacher = FactoryBot.build(:teacher, email: 'aaron@example.com')
    teacher.valid?
    expect(teacher.errors[:email]).to include('has already been taken')
  end
end
