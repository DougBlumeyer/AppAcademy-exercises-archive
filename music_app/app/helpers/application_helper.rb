module ApplicationHelper
  def ugly_lyrics(lyrics)
    "<pre>\n&#9835;#{h(lyrics).gsub("\n","\n&#9835; ")
      .gsub("&#9835; \n","\n")}</pre>".html_safe
  end
end
