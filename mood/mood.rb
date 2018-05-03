require 'date'
require 'time'
require_relative "diary"

class Mood
	attr_accessor :mood
	attr_accessor :reason
	attr_accessor :timestamp

	def to_s
		"On #{Date.parse(@timestamp).strftime('%m/%d/%Y')} at #{Time.parse(@timestamp).strftime('%I:%M%p')}, my mood was '#{@mood}' because '#{@reason.chomp}'"
	end
end

def askForMood
	puts "What's your mood right now?"
	gets.chomp.to_i
end

def askForReason
	puts "Why?"
	gets.chomp
end

def prompt(diary)
	entry = Mood.new
	puts diary.get_scale
	entry.mood = askForMood
	entry.reason = askForReason
	entry.timestamp = Time.now
	entry
end

diary = Diary.new

# No args = prompt
# --reset = clears the file
# --list = lists all the entries in the file

if ARGV.count == 0
	diary.SaveEntry(prompt(diary))
	puts "Saved."
elsif ARGV.count == 1
	# look into an Options parser lib?
	if ARGV[0] == "--list"
		diary.entries.each { |e| puts e.to_s}

		if diary.entries.count > 0
			puts "-" * 10
			puts "Entries: #{diary.entries.count}"
		end
	elsif ARGV[0] == "--reset"
		puts "Are you sure you want to clear the diary? (y/N)"
		answer = STDIN.gets.chomp

		if(answer.downcase == "y")
			diary.Clear
			puts "Diary has been cleared."
		else
			puts "Ok, NOT clearing the diary this time."
		end
	else
		puts "I don't know what you want to do. Exiting."
	end
end