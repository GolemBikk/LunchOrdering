module ApplicationHelper
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
end
