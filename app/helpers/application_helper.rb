module ApplicationHelper
  def month_enum(head, tail)
    Enumerator.new do |yielder|
      now = head.beginning_of_month
      while now <= tail
        yielder << now
        now = now.next_month
      end
    end
  end

  def bootstrap_class(name)
    case name
    when 'notice'
      'info'
    when 'alert'
      'warning'
    else
      name
    end
  end
end
