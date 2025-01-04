class Reports::ExportsController < ApplicationController
  def create
    report_name  = export_params[:name]
    html_content = parse_html_content export_params[:data]

    report_data = parse_html_table report_name, html_content
    send_data report_data,
              filename: "#{report_name}.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
              disposition: "attachment"
  end

  private
    def export_params
      params.expect(report: %i[ name data ])
    end

    def parse_html_content(raw_data)
      CGI.unescape Base64.decode64(raw_data)
    end

    def parse_html_table(name, html_content)
      doc = Nokogiri::HTML(html_content)

      headers = parse_headers doc
      rows    = parse_rows doc

      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(name: name) do |sheet|
          text_center = sheet.styles.add_style(alignment: { horizontal: :center }, border: { color: "FF000000", style: :thin })
          text_left = sheet.styles.add_style(alignment: { horizontal: :left }, border: { color: "FF000000", style: :thin })
          text_right = sheet.styles.add_style(alignment: { horizontal: :right }, border: { color: "FF000000", style: :thin })

          headers.each do |header|
            cells = []
            merged_cells = []
            index = 0
            header.each do |cell|
              colspan = cell[:colspan]
              value = cell[:value].to_s.strip
              if colspan.positive?
                cells += [ value ] + ([ "" ] * (colspan-1))
                merged_cells << [ index, index+colspan-1 ]
                index += colspan
              else
                cells << value
                index += 1
              end
            end
            sheet.add_row cells, style: text_center

            merged_cells.each do |merged|
              sheet.merge_cells sheet.rows.last.cells[merged.first..merged.last]
            end
          end

          rows.each do |row|
            cells = row.map { |r| r[:value].to_s.strip }
            styles = [ text_left ]
            styles += [ text_right ] * (cells.size - 1)

            sheet.add_row cells, style: styles
          end
        end
      end.to_stream.read
    end

    def parse_headers(doc)
      head = doc.at("thead")
      head.xpath(".//tr").map do |header|
        cols = []
        header.xpath(".//th").each_with_index do |subheader, index|
          colspan = subheader[:colspan].to_i
          value = subheader.text

          cols << { colspan:, value:, index: }
        end
        cols
      end
    end

    def parse_rows(doc)
      body = doc.at("tbody")
      body.xpath(".//tr").map do |row|
        cols = []
        row.xpath(".//td").each_with_index do |col, index|
          cols << { value: col.text, index: }
        end
        cols
      end
    end
end
