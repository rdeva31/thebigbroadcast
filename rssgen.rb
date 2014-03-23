class RSSGen
	attr_accessor :title
	attr_accessor :description, :link, :build_date, :pub_date, :language,
		:copyright, :managing, :web_master, :last_build, :category,
		:generator, :docs, :cloud, :ttl, :image, :rating, :text_input,
		:skip_hours, :skip_days, :items

	class Item
		attr_reader :title
		attr_reader :description
		attr_reader :link
		attr_reader :guid
		attr_reader :pub_date
		attr_reader :mime

		def initialize(title, link, description = nil,
			       guid = nil, pub_date = nil, mime = nil)
			@title = title
			@description = description
			@link = link
			@guid = guid
			@pub_date = pub_date
			@mime = mime
		end
	end


	def initialize(title, description, link, build_date = nil,
		       pub_date = nil, language = nil, copyright = nil,
		       managing = nil, web_master = nil, last_build = nil,
		       category = nil, generator = nil, docs = nil,
		       cloud = nil, ttl = nil, image = nil, rating = nil,
		       text_input = nil, skip_hours = nil, skip_days = nil)
		@title = title
		@description = description
		@link = link
		@build_date = build_date
		@pub_date = pub_date
		@language = language
		@copyright = copyright
		@managing = managing
		@web_master = web_master
		@last_build = last_build
		@category = category
		@generator = generator
		@docs = docs
		@cloud = cloud
		@ttl = ttl
		@image = image
		@rating = rating
		@text_input = text_input
		@skip_hours = skip_hours
		@skip_days = skip_days
		@items = Array.new
	end


	def <<(item)
		add(item)
	end

	def add(item)
		@items << item
	end

	def to_s()
		return generate()
	end

	def generate()
		%Q{<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
	<channel>
			#{generate_title()}
			#{generate_description()}
			#{generate_link()}
			#{generate_last_build_date()}
			#{generate_pub_date()}
			#{generate_ttl()}

			#{generate_items()}
	</channel>
</rss>
		}
	end

	private

	def generate_tag(tag, content, attributes = nil)
		content = content.strip if content
		if content != nil then
			return %Q{
			<#{tag} #{attributes}>
				#{content}
			</#{tag}>}
		elsif content == "" then
			return %Q{
			<#{tag} #{attributes} />
			}
		else
			return ""
		end
	end

	def generate_title()
		return generate_tag("title", @title)
	end

	def generate_description()
		return generate_tag("description", @description)
	end

	def generate_link()
		return generate_tag("link", @link)
	end

	def generate_last_build_date()
		return generate_tag("lastBuildDate", @last_build ?
				    @last_build.rfc822 : nil)
	end

	def generate_pub_date()
		return generate_tag("pubDate", @pub_date ?
				    @pub_date.rfc822 : nil)
	end

	def generate_ttl()
		return generate_tag("ttl", @ttl)
	end

	def generate_items()
		items = ""
		@items.each do |i|
			items += generate_item(i)
		end
		return items
	end

	def generate_item(item)
		return generate_tag("item", %Q{
			#{generate_tag("title", item.title)}
			#{generate_tag("description", item.description)}
			#{generate_tag("link", item.link)}
			#{generate_tag("guid", item.guid ? item.guid : item.link)}
			#{generate_tag("pubDate", item.pub_date ?
					item.pub_date.rfc822 : nil)}
			#{generate_tag("enclosure", "",
					%Q{url="#{item.link}" length="0" type="#{item.mime}"})}
		})
	end
end
