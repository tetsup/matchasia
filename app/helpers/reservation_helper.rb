module ReservationHelper
  def style_class_by_reserved_rate(rate)
    if rate.blank?
      nil
    elsif rate > 85
      'reserved-rate-high'
    elsif rate > 50
      'reserved-rate-middle'
    else
      'reserved-rate-low'
    end
  end

  def reserved_rate(reservations_count, lessons_count)
    if lessons_count.blank?
      nil
    else
      (reservations_count || 0) * 100 / lessons_count
    end
  end

  def create_daily_query_params(month)
    {
      'span' => 'daily',
      'query[start_date]' => month.to_s(:date_query),
      'query[end_date]' => month.end_of_month.to_s(:date_query)
    }
  end
end
