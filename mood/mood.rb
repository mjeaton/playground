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
				entry.timestamp = ts
				entry.mood = m
				entry.reason = r

				@Entries.push(entry)
			end
		end
	end

	def SaveEntry(entry)
		begin
			diary = File.open(FILENAME, "a") 
			diary.puts "#{entry.timestamp}\t#{entry.mood}\t#{entry.reason}"
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
	attr_accessor :mood
	attr_accessor :reason
	attr_accessor :timestamp

	def to_s
		"#{@timestamp}, my mood was #{@mood} because '#{@reason.chomp}'"
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
		diary.Entries.each { |e| puts e.to_s}

		if diary.Entries.count > 0
			puts "-" * 10
			puts "Entries: #{diary.Entries.count}"
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