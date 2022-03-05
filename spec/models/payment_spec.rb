require 'rails_helper'
require 'stripe_mock'

RSpec.describe Payment, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  describe '#stripe_session' do
    let(:payment) { build(:payment) }
    subject { payment.stripe_session('dummy_success_url', 'dummy_canceled_url').payment_intent }
    it { is_expected.to starting_with('pi_') }
  end

  describe '#from_event' do
    let(:succeeded_event) { StripeMock.mock_webhook_event('payment_intent.succeeded') }
    let(:student) { create(:student, stripe_customer_id: succeeded_event.data.object.customer) }
    let!(:payment_with_intent) { create(:payment, student: student, payment_intent: succeeded_event.data.object.id) }
    subject { Payment.from_event(succeeded_event) }
    it { is_expected.to eq payment_with_intent }
  end

  describe '#from_event_raise_error' do
    let(:succeeded_event) { StripeMock.mock_webhook_event('payment_intent.succeeded') }
    subject { -> { Payment.from_event(succeeded_event) } }

    context 'when_with_no_payment' do
      it { is_expected.to raise_error(ActionController::BadRequest) }
    end

    context 'when_with_different_customer_id' do
      let(:student) { create(:student, stripe_customer_id: 'cus_different_id_999999999999') }
      let!(:payment_with_intent) { create(:payment, student: student, payment_intent: succeeded_event.data.object.id) }
      it { is_expected.to raise_error(ActionController::BadRequest) }
    end
  end

  describe '#extend_tickets!' do
    context 'one_ticket' do
      let(:payment) { create(:payment, :with_payment_intent) }
      it 'extends_tickets' do
        expect { payment.extend_tickets! }.to change(payment.student, :tickets).by(1)
      end
    end

    context 'three_tickets' do
      let(:payment) { create(:payment, :price_three_tickets) }
      it 'extends_tickets' do
        expect { payment.extend_tickets! }.to change(payment.student, :tickets).by(3)
      end
    end

    context 'five_tickets' do
      let(:payment) { create(:payment, :price_five_tickets) }
      it 'extends_tickets' do
        expect { payment.extend_tickets! }.to change(payment.student, :tickets).by(5)
      end
    end

    context 'already_extended' do
      let(:payment) { create(:payment, :already_extended) }
      it 'extends_tickets' do
        expect { payment.extend_tickets! }.to change(payment.student, :tickets).by(0)
      end
    end
  end
end
