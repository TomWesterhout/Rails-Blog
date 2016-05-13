# app/views/articles/feed.rss.builder

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "Philosophy blog"
		xml.description "A blog dedicated to philosophy"
		xml.link root_url

		@articles.each do |article|
			xml.item do
				xml.title article.title
				xml.description article.body
				xml.pubDate article.created_at.to_s(:rfc822)
				xml.link articl_url(article)
				xml.guid article_url(article)
			end
		end
	end
end