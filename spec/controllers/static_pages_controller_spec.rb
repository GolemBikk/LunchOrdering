require 'rails_helper'

describe StaticPagesController, type: :controller do
  subject { response }

  context 'GET home' do
    before { get :home }

    it { is_expected.to render_template('home') }
    it 'assigns weekdays' do
      expect(assigns(:weekdays)).to eq(weekdays)
    end
  end
end