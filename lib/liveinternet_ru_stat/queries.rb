module LiveinternetRuStatQueries
  def queries(date = nil, period = nil, total = 'yes', min_hits = nil)
    params = { per_page: 100, page: 1, lang: :en }
    params[:date] = date.to_s if date
    params[:period] = period  if period
    params[:total] = total if total

    keywords = []

    catch :min_hits_error do
      loop do
        params_str = params.to_a.collect { |par| par.join '=' }.join('&')
        doc = Nokogiri::HTML.parse get("/queries.html?#{params_str}").body

        doc.css('table[bgcolor="#e8e8e8"] tr').each do |row|
          link = row.at_css 'label a'
          next unless link

          hits = row.at_css('td:nth-child(3)').content.to_f
          throw :min_hits_error if min_hits && min_hits > hits

          keywords << {
            text:         link.content,
            hits:         hits,
            hits_prev:    row.at_css('td:nth-child(4)').content.to_f,
            percent:      row.at_css('td:nth-child(5)').content.to_f,
            percent_prev: row.at_css('td:nth-child(6)').content.to_f,
          }
        end

        break unless 'next' == doc.css('a.high').last.content
        params[:page] += 1
      end
    end

    keywords
  end
end