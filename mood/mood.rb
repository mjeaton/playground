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

def ask_for_mood
	puts "What's your mood right now?"
	gets.chomp.to_i
end

def ask_for_reason 
	puts "Why? (shift-enter for multiple lines. 'END' <enter> to save."

	$/ = "END"
	STDIN.gets
end

def prompt_and_get_entry(diary)
	entry = Mood.new
	puts diary.get_scale
	entry.mood = ask_for_mood
	entry.reason = ask_for_reason
	entry.timestamp = Time.now
	entry
end

def print_entries(diary)
	diary.entries.each { |e| puts e.to_s}

	if diary.entries.count > 0
		puts "-" * 10
		puts "Entries: #{diary.entries.count}"
	end
end

def print_help
	puts "My Mood Diary"
	puts ""
	puts "Usage: [--help] [--reset] [--list]"
	puts ""
	puts "Used with no arguments, you will be prompted for your mood and a reason for the current mood."
	puts ""
	puts "--list will display a list of all entries."
	puts "--reset will clear the contents of the current mood diary."
	puts "--help displays this help text."
	puts ""
end

diary = Diary.new

# No args = prompt
# --reset = clears the file
# --list = lists all the entries in the file

if ARGV.count == 0
	diary.SaveEntry(prompt_and_get_entry(diary))
	puts "Saved."
elsif ARGV.count == 1
	# look into an Options parser lib?
	if ARGV[0] == "--list"
		print_entries(diary)
	elsif ARGV[0] == "--help"
		print_help
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