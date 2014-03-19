require 'sinatra'
require './thebigbroadcast.rb'
require './rssgen.rb'

get '/' do
	"Nothing to show here"
end

get '/rss.xml' do
	rss = RSSGen.new("The Big Broadcast", %q{
The Big Broadcast is WAMU 88.5's longest-running program. The show features a collection of vintage radio programs from the 1930s, '40s, and '50s, including Gunsmoke, The Jack Benny Show, The Lone Ranger,Suspense, Fibber McGee and Molly and Superman. The Big Broadcast airs Sunday from 7 until 11 p.m. and has been a weekly feature on WAMU 88.5 since 1964.
	}, "http://wamu.org/programs/the_big_broadcast")
	TheBigBroadcast.get(10).each do |item|
		rss << item
	end

	content_type 'application/rss+xml'
	rss.generate
end
