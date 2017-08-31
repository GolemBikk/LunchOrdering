module ApplicationHelper
  def full_title(page_title)
    base_title = 'Lunch Ordering'
    return base_title if page_title.empty?
    "Lunch Ordering | #{page_title}"
  end

  def error_alert(error)
    unless error.nil?
      flash.now[:danger] = 'Please review the problems below.'
    end
  end

  def flash_alert_converter(flash_key)
    case flash_key
    when 'error'
      'danger'
    when 'notice'
      'info'
    when 'alert'
      'info'
    else
      flash_key
    end
  end

  def available_for_order? (day)
    day >= Date.today
  end
end
