module SidebarHelper
  def nav_link(path, title, icon_name)
    tag.li do
      link_to path, class: nav_link_class(path) do
        concat inline_svg_tag icon_name, class: nav_icon_class(path)
        concat title
      end
    end
  end

  private
    def nav_link_class(path)
      current_page?(path) ? "group nav-link-base nav-link-active" : "group nav-link-base nav-link-default"
    end

    def nav_icon_class(path)
      current_page?(path) ? "nav-icon-base nav-icon-active" : "nav-icon-base nav-icon-default"
    end
end
