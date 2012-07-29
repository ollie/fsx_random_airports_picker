require 'bundler/setup'

require 'json'

codes = {}

File.open( './resources/fs10.Airports.dat', 'r' ).each do |line|
  next unless line.match /^[0-9A-Z]/
  parts = line.split(',')
  code, latitude, longitude, country = parts.first.strip, parts[1].strip, parts[2].strip, parts.last.strip
  codes[country] ||= []
  codes[country] << { :code => code, :latitude => latitude, :longitude => longitude }
end

File.open( './resources/codes.txt', 'w' ) do |file|
  file << JSON.dump( codes )
end

puts "Done."