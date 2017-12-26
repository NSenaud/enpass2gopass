#!/usr/bin/env ruby

require 'csv'
require 'optparse'

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] filename"

  FORCE = false
  opts.on("-f", "--force", "Overwrite existing records") { FORCE = true }
  DEFAULT_GROUP = ""
  opts.on("-d", "--default GROUP", "Place uncategorised records into GROUP") { |group| DEFAULT_GROUP = group }
  opts.on("-h", "--help", "Display this screen") { puts opts; exit }

  opts.parse!
end

# Check for a filename
if ARGV.empty?
  puts optparse
  exit 0
end

# Get filename of csv file
filename = ARGV.join(" ")
puts "Reading '#{filename}'..."

class Entry
  def initialize website, username, password
    @website, @username, @password = website, username, password
  end

  def name
    s = ""
    s << @grouping + "/" unless @grouping.empty?
    s << @name unless @name == nil
    s.gsub(/ /, "_").gsub(/'/, "")
  end

  def to_s
    s = ""
    s << "username: #{@username}\n"
    s << "password: #{@password}\n"
    s << "url: #{@website}\n"
    return s
  end
end

entries = []
# skipped_entries = []

CSV.foreach(filename) do |row|
  website = row[0]
  username = row.each_cons(2) { |item, next_item| break next_item if item == 'username' }
  password = row.each_cons(2) { |item, next_item| break next_item if item == 'password' }
  entries << Entry.new(website, username, password)
end

puts entries
