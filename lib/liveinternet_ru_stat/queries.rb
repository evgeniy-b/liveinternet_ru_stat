module LiveinternetRuStatQueries
  def queries(date = nil, period = nil, total = true, min_hits = nil)
    params = { per_page: 100, page: 1, lang: :en }
    params[:date] = date.to_s if date
    params[:period] = period  if period
    params[:total] = 'yes' if total

    keywords = []

    catch :min_hits_error do
      loop do
        params_str = params.to_a.collect { |par| par.join '=' }.join('&')
        html = get("/queries.html?#{params_str}").body
        doc = Nokogiri::HTML.parse html

        doc.css('table[bgcolor="#e8e8e8"] tr').each do |row|
          link = row.at_css 'label a'
          next unless link

          td = row.css('td')

          hits = td[2].content.gsub(",", "").to_f
          throw :min_hits_error if min_hits && min_hits > hits

          keywords << {
            text:         link.content,
            hits:         hits,
            hits_prev:    td[4].content.gsub(",", "").to_f,
            percent:      td[3].content.to_f,
            percent_prev: td[5].content.to_f,
          }
        end

        link = doc.css('a.high').last
        break if !link || 'next' != link.content

        params[:page] += 1
      end
    end

    keywords
  end
end