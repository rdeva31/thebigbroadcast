require 'net/http'
require 'date'
require './rssgen.rb'

class TheBigBroadcast
	def self.get(count)
		shows = Array.new
		today = Date.parse(DateTime.now.to_s)
		last_sunday = today

		until last_sunday.cwday == 7 do
			last_sunday -= 1
		end

		count.times do |c|
			day = last_sunday - (7 * c)
			link = day.strftime(
					"http://downloads.wamu.org/mp3/bb/%y/%m/b1%y%m%d.mp3");
			if (valid(link)) then
				shows << RSSGen::Item.new(
				"The Big Broadcast #{day.strftime("%m/%-d/%y")}",
				link, "No description", link, day, "audio/mpeg")
			end
		end

		return shows
	end

	private
	def self.valid(link)
		begin
			uri = URI.parse(link)
			req = Net::HTTP.new(uri.host, uri.port).request_head(uri.path)
			return !(req.code =~ /4../)
		rescue URI::InvalidURIError => e
			return false
		end
	end
end
