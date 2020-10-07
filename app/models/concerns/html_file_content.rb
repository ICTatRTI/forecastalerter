module HtmlFileContent extend ActiveSupport::Concern

  def file_to_html_table file
    html = Paperclip.io_adapters.for(file).read
    doc = Nokogiri::HTML(html)

    headers = []
    rows = []
    doc.xpath('//*/table/tr').each_with_index do |row, i|
      if i == 0
        row.xpath('th').each do |th|
          headers << th.text
        end
      else
        rows[i] = {}
        row.xpath('td').each_with_index do |td, j|
          rows[i][headers[j]] = td.text.strip
        end
      end
    end

    return rows.compact
  end

  def map_title_urls titles, html
    doc = Nokogiri::HTML(html)
    title_urls = {}
    doc.css('h2.award-title a').each do |a|
      titles.each do |title|
        if a.text == title
          title_urls[title] = "https://www.usaid.gov" + a['href'].split('?')[0]
        end
      end
    end
    return title_urls
  end

  def html_to_awards html
    doc = Nokogiri::HTML(html)
    doc.css('.business-forecast-award').map do |award_div|
      award = {}
      url = award_div.at_css('.award-title a')['href']
      award['url'] = "https://www.usaid.gov" + URI(url).path
      award['usaid_web_id'] = award['url'].split('/').last
      award['title'] = award_div.at_css('.award-title a').text

      header = award_div.at_css('.header-info')
      header.children.each do |he|
        if he.text.downcase.include?(Award::HEADERS[:code].downcase)
          award['code'] = he.text.split(':').last.squish
        elsif he.text.downcase.include?(Award::HEADERS[:fiscal_year].downcase)
          award['fiscal_year'] = he.text.split(':').last.squish
        elsif he.text.downcase.include?(Award::HEADERS[:last_modified_at].downcase)
          award['last_modified_at'] = he.text.split(':').last.squish
        end
      end

      award['description'] = award_div.at_css('.award-description').text

      labels = award_div.css('.award-details .details-column .label').map(&:text)
      labels += award_div.css('.award-details .details-tri-columns .label').map(&:text)
      values = award_div.css('.award-details .details-column .value').map(&:text)
      values += award_div.css('.award-details .details-tri-columns .value').map(&:text)
      labels.each_with_index do |label, i|
        if Award::HEADERS.key(label.gsub(/:\z/,''))
          award[Award::HEADERS.key(label.gsub(/:\z/,'')).to_s] = values[i].squish
        else
          logger.info "Unable to find key '#{label}' for HTML awards"
        end
      end

      award
    end
  end

  def json_to_grants json
    data = JSON.parse(json)
    return data['oppHits']
  end

end