#!/usr/bin/env ruby

require 'csv'
require 'optparse'
require 'open3'

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
  def initialize website, username, password, email
    @website, @username, @password, @email = website, username, password, email
  end

  def name
    s = ""
    s << @website + "/" unless @website.empty?
    s << ( @username ? @username : @email )
    s.gsub(/ /, "_").gsub(/'/, "")
  end

  def password
    @password
  end

  def to_s
    s = ""
    s << "username: #{@username}\n"
    s << "email: #{@email}\n"
    s << "password: #{@password}\n"
    s << "url: #{@website}\n"
    return s
  end
end

entries = []
skipped_entries = []

CSV.foreach(filename) do |row|
  website = row[0]
  username = row.each_cons(2) { |item, next_item| break next_item if item == 'username' or item == 'Username' }
  password = row.each_cons(2) { |item, next_item| break next_item if item == 'password' or item == 'Password' }
  email = row.each_cons(2) { |item, next_item| break next_item if item == 'email' or item == 'Email' }

  if email != nil or username != nil and password != nil
    entries << Entry.new(website, username, password, email)
  else
    skipped_entries << Entry.new(website, username, password, email)
  end
end

for entry in entries do
  cmd = ""
  cmd << "/usr/bin/gopass insert "
  cmd << entry.name
  puts cmd

  Open3.popen3(cmd) do |i, o, e, t|
    i.write entry.password
    i.close
    puts o.read
  end
end

puts "\n---\n"
puts "Skipped entries:"
puts skipped_entries
