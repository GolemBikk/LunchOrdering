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
end
