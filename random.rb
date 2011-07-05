require 'trollop'
require 'json'
require_relative 'distance'

opts = Trollop.options do
	opt :international, 'International? (default: false)', :default => false, :short => :i, :type => :bool
	opt :count, 'How many picks do you want?', :default => 5, :short => :c, :type => :int
	opt :brief, "Don't show link to a map (default: false)", :default => false, :short => :b, :type => :bool
	opt :highlight, 'Highlight airport codes (default: false)', :default => false, :short => :H, :type => :bool
end

class Randomizer
	attr_accessor :international, :count, :brief, :highlight

	def initialize( file_name )
		@data = JSON.parse File.read( 'codes.txt' )
	end

	def pick_country
		@country = @data.keys.sample
	end

	def pick_two
		pick_country
		country_one	= @country
		airport_one	= pick!
		code_one = airport_one['code']
		country_two	= @country
		airport_two	= pick!
		code_two = airport_two['code']

		p1 = Point.new do |p|
			p.latitude = airport_one['latitude']
			p.longitude = airport_one['longitude']
		end

		p2 = Point.new do |p|
			p.latitude = airport_two['latitude']
			p.longitude = airport_two['longitude']
		end

		distance = Distance.calc p1, p2

		code_info		= "#{ code_one.rjust 4 }-#{ code_two.ljust 4 }"
		if @highlight
			map_info		= "http://www.gcmap.com/mapui?P=\033[1m#{ code_one }-#{ code_two }\033[0m".ljust 46
		else
			map_info		= "http://www.gcmap.com/mapui?P=#{ code_one }-#{ code_two }".ljust 38
		end
		country_info	= country_one == country_two ? country_one : "#{ country_one } -> #{ country_two }"

		puts @brief ? "#{ code_info } (#{ country_info }) #{ distance } NM" : "#{ map_info } (#{ country_info }) #{ distance } NM"
	end

	def pick!
		raise 'Out of data!' if @data.size <= 1

		airport_index	= rand @data[@country].size
		airport_data	= @data[@country].delete_at airport_index

		if @data[@country].empty?
			@data.delete @country
			pick_country
		end

		pick_country if @international
		# puts "#{ @country }: #{ airport_code }"
		# @data.each { |country, codes| puts "#{ country }: #{ codes.size }" }
		# puts '=============='
		airport_data
	end
end

r = Randomizer.new 'codes.txt'
r.international = opts[:international]
r.count = opts[:count]
r.brief = opts[:brief]
r.highlight = opts[:highlight]

r.count.times do
	r.pick_two
end