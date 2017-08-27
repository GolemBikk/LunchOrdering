require 'rails_helper'

RSpec.describe 'Static pages', type: :feature do
  subject { page }

  describe ' when visit Home page' do
    before { visit home_path }

    it { should have_title(full_title 'Home') }
    it { should have_link('Show menu', href: '#', count: 5) }
  end
end