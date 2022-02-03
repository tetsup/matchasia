module ReservationHelper
  def get_style_class(rate)
    if rate.blank?
      nil
    elsif rate > 85
      'reservated-rate-high'
    elsif rate > 50
      'reservated-rate-middle'
    else
      'reservated-rate-low'
    end
  end

  def colored_td(reservations_count, lessons_count)
    params = {}
    params[:reservations_count] = reservations_count || 0
    params[:lessons_count] = lessons_count
    params[:reservated_rate] = lessons_count && (params[:reservations_count] * 100 / params[:lessons_count])
    params[:style_class] = get_style_class(params[:reservated_rate])
    render inline: <<-HAML.strip_heredoc, type: :haml, locals: params
      - if lessons_count.blank?
        %td -
      - else
        %td{class: "#{params[:style_class]}"}
          #{params[:reservations_count]} / #{params[:lessons_count]}
          %br
          (#{params[:reservated_rate]}%)
    HAML
  end

  def create_daily_query_params(month)
    {
      'span' => 'daily',
      'query[start_date]' => month.to_s(:date_query),
      'query[end_date]' => month.end_of_month.to_s(:date_query)
    }
  end
end
