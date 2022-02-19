require 'rails_helper'

RSpec.describe Admin, type: :model do
  it 'is valid with an email and password' do
    admin = FactoryBot.build(:admin)
    expect(admin).to be_valid
  end

  it 'is invalid without an email address' do
    admin = FactoryBot.build(:admin, email: nil)
    admin.valid?
    expect(admin.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password' do
    admin = FactoryBot.build(:admin, password: nil)
    admin.valid?
    expect(admin.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:admin, email: 'admin@example.com')
    admin = FactoryBot.build(:admin, email: 'admin@example.com')
    admin.valid?
    expect(admin.errors[:email]).to include('has already been taken')
  end
end
