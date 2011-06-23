require 'json'

codes = {}

File.open( 'fs10.Airports.dat', 'r' ).each do |line|
	next unless line.match /^[0-9A-Z]/
	parts = line.split(',')
	code, country = parts.first.strip, parts.last.strip
	codes[country] ||= []
	codes[country] << code
end

File.open( 'codes.txt', 'w' ) do |file|
	file << JSON.dump( codes )
end

puts "Done."