module TabsHelper
  def mobile_tab_select(tab_links)
    select_tag :tabs, tab_options(tab_links), data: { controller: "tab", action: "tab#redirect" }, class: "tab-select"
  end

  private

    def tab_options(tab_links)
      options_for_select(tab_links.map { |link| [ link.title, link.path ] }, tab_links.select { |link| link.is_active == true }.first.path)
    end
end
