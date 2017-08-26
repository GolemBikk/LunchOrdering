require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe ' when open new page' do
    let(:default_title) { 'Lunch Ordering' }

    describe ' with own title' do
      let(:page_title) { 'Some title' }
      let(:full_page_title) { full_title page_title }

      it ' should have title' do
        expect(full_page_title).to eq("#{default_title} | #{page_title}")
      end
      it " shouldn't have title" do
        expect(full_page_title).not_to eq(default_title)
      end
    end

    describe ' without title' do
      let(:full_page_title) { full_title '' }

      it ' should have title' do
        expect(full_page_title).to eq(default_title)
      end
    end
  end

  describe ' when show form page' do
    describe ' at first time' do
      let(:error_notification) { nil }
      before do
        error_alert error_notification
      end

      it { expect(flash.now[:danger]).to eq(error_notification) }
    end

    describe ' after sending invalid data' do
      let(:error_notification) { 'Please review the problems below.' }
      before do
        error_alert error_notification
      end

      it { expect(flash.now[:danger]).to eq(error_notification) }
    end
  end

  describe ' when show alert' do
    describe ' with default flash key' do
      it 'should equal' do
        flash_keys = %w[danger warning info success]
        flash_keys.each do |flash_key|
          expect(flash_alert_converter flash_key).to eq(flash_key)
        end
      end
    end
    describe ' with specific flash key' do
      it ' should equal' do
        expect(flash_alert_converter 'error').to eq('danger')
        expect(flash_alert_converter 'notice').to eq('info')
        expect(flash_alert_converter 'alert').to eq('info')
      end
    end
  end
end