require 'rails_helper'

RSpec.describe 'Static pages', type: :feature do
  subject { page }

  describe ' when visit Home page' do
    before { visit home_path }

    it { should have_title(full_title 'Home') }
    it { should have_link('Show menu', href: menu_path('monday')) }
    it { should have_link('Show menu', href: menu_path('tuesday')) }
    it { should have_link('Show menu', href: menu_path('wednesday')) }
    it { should have_link('Show menu', href: menu_path('thursday')) }
    it { should have_link('Show menu', href: menu_path('friday')) }
  end
end