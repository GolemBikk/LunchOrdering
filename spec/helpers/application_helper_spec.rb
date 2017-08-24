require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'when send sign_up form' do
    describe 'with invalid data' do
      let(:error_notification) { 'Please review the problems below.' }
      before do
        error_alert error_notification
      end
      let(:flash_message) { flash.now[:danger] }

      it { expect(flash_message).to eq(error_notification) }
    end

    describe 'with valid data' do
      let(:error_notification) { nil }
      before do
        error_alert error_notification
      end
      let(:flash_message) { flash.now[:danger] }

      it { expect(flash_message).to eq(error_notification) }
    end
  end

  describe 'when show alert' do
    describe 'with default flash key' do
      it 'should equal' do
        flash_keys = %w[danger warning info success]
        flash_keys.each do |flash_key|
          expect(flash_alert_converter flash_key).to eq(flash_key)
        end
      end
    end
    describe 'with other flash key' do
      it 'should equal' do
        expect(flash_alert_converter 'error').to eq('danger')
        expect(flash_alert_converter 'notice').to eq('info')
        expect(flash_alert_converter 'alert').to eq('info')
      end
    end
  end
end