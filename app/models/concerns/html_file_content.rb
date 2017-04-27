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

end