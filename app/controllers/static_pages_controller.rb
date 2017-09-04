class StaticPagesController < ApplicationController
  def home
    @weekdays = WeekdayMenu::WEEKDAYS
  end
end
