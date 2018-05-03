require 'date'
class Diary
	attr_accessor :Entries

	FILENAME = "moodDiary.txt".freeze
	private_constant = :FILENAME

	def initialize
		@Entries = []
		# check to see if the file exists
		if File.file? FILENAME
			# load the entries from the file
			File.foreach(FILENAME) do |l|
				# parse each line since it's tab-delimited

				# this could all be cleaner!
				ts, m, r = l.split(/\t/)
				entry = Mood.new
				entry.Timestamp = ts
				entry.Mood = m
				entry.Reason = r

				@Entries.push(entry)
			end
		end
	end

	def SaveEntry(entry)
		begin
			diary = File.open(FILENAME, "a") 
			diary.puts "#{entry.Timestamp}\t#{entry.Mood}\t#{entry.Reason}"
		rescue IOError => e
			puts e
		ensure
			diary.close unless diary.nil?
		end
	end

	def Clear
		begin
			diary = File.open(FILENAME, "w") 
		rescue IOError => e
			puts e
		ensure
			diary.close unless diary.nil?
		end
	end

	# does this belong here?
	def GetMoodScale 
		"Mood scale: 1=Terrible, 2=Bad, 3=Okay, 4=Good, 5=Great"
	end
end

class Mood
	attr_accessor :Mood
	attr_accessor :Reason
	attr_accessor :Timestamp

	def to_s
		"#{@Timestamp}, my mood was #{@Mood} because '#{@Reason.chomp}'"
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
	puts diary.GetMoodScale 
	entry.Mood = askForMood
	entry.Reason = askForReason
	entry.Timestamp = Time.now
	entry
end

diary = Diary.new

if ARGV.count == 0
	diary.SaveEntry(prompt(diary))
	puts "Saved."
elsif ARGV.count == 1
	# look into an Options parser lib?
	if ARGV[0] == "--list"
		diary.Entries.each { |e| puts e.to_s}

		puts "-" * 10
		puts "Entries: #{diary.Entries.count}"
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