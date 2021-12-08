require 'rails_helper'

RSpec.describe Student, type: :model do
  it 'is valid with a username, email, password, and tickets' do
    student = FactoryBot.build(:student)
    expect(student).to be_valid
  end

  it 'is invalid without a username' do
    student = FactoryBot.build(:student, username: nil)
    student.valid?
    expect(student.errors[:username]).to include("can't be blank")
  end

  it 'is invalid without an email address' do
    student = FactoryBot.build(:student, email: nil)
    student.valid?
    expect(student.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password' do
    student = FactoryBot.build(:student, password: nil)
    student.valid?
    expect(student.errors[:password]).to include("can't be blank")
  end

  it 'is invalid without tickets' do
    student = FactoryBot.build(:student, tickets: nil)
    student.valid?
    expect(student.errors[:tickets]).to include("can't be blank")
  end

  it 'is invalid with less than 0 tickets' do
    student = FactoryBot.build(:student, tickets: -1)
    student.valid?
    expect(student.errors[:tickets]).to include('must be greater than or equal to 0')
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:student, email: 'aaron@example.com')
    student = FactoryBot.build(:student, email: 'aaron@example.com')
    student.valid?
    expect(student.errors[:email]).to include('has already been taken')
  end
end
