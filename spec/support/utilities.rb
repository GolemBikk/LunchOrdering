module Utilities
  def user_sign_in(user)
    visit new_user_session_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def full_title(page_title)
    base_title = 'Lunch Ordering'
    return base_title if page_title.empty?
    "Lunch Ordering | #{page_title}"
  end

  def next_week_beginning
    Date.today.beginning_of_week + 7
  end

  def weekdays
    %w[monday tuesday wednesday thursday friday]
  end

  def to_weekday(date)
    date.strftime('%A').downcase
  end

  def to_date(weekday)
    date = Date.today.beginning_of_week
    until to_weekday(date) == weekday do
      date = date.tomorrow
    end
    date
  end

  def json
    JSON.parse(response.body)
  end
end
