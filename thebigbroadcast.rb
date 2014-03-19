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
			shows << RSSGen::Item.new(
				"The Big Broadcast #{day.day}/#{day.month}/#{day.year}",
				day.strftime(
					"http://downloads.wamu.org/mp3/bb/%y/%m/b1%y%m%d.mp3"),
				"No description")
		end

		return shows
	end
end
