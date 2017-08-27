class StaticPagesController < ApplicationController
  def home
    @weekdays = %w[monday tuesday wednesday thursday friday]
  end
end
