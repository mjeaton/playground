class Diary
	def SaveEntry(entry, delimiter="=")
		begin
			diary = File.open("moodDiary.txt", "a") 
			diary.puts delimiter * 10
			diary.puts entry.Timestamp 
			diary.puts entry.Mood 
			diary.puts entry.Reason 
		rescue IOError => e
			puts e
		ensure
			diary.close unless diary.nil?
		end
	end

	def Clear
		begin
			diary = File.open("moodDiary.txt", "w") 
		rescue IOError => e
			puts e
		ensure
			diary.close unless diary.nil?
		end
	end

	def GetMoodScale 
		"Mood scale: 1=Terrible, 2=Bad, 3=Okay, 4=Good, 5=Great"
	end
end

class Mood
	attr_accessor :Mood
	attr_accessor :Reason
	attr_accessor :Timestamp

	def initialize(mood, reason, time)
		@Mood = mood
		@Reason = reason
		@Timestamp = time
	end
end

diary = Diary.new

if ARGV.count == 0
	# wrap this in a Prompt method that can be called from 
	# other places.
	puts diary.GetMoodScale 
	puts "What's your mood right now?"
	currentMood = gets.chomp.to_i

	puts "Why?"
	currentMoodReason = gets.chomp
elsif ARGV.count == 1

	# some of this feels dirty and not very Ruby-like
	# need to figure out a better way to to handle the answer (I have some ideas...)
	# also, the multiple exits(0) really bother me.1

	# look into an Options parser lib
	if ARGV[0] == "--reset"
		puts "Are you sure you want to clear the diary? (y/N)"
		answer = STDIN.gets.chomp

		if(answer == "" || answer == 'N' || answer == 'n')
			puts "Ok, NOT clearing the diary this time."
		else
			diary.Clear
			puts "Diary has been cleared."
		end
		exit(0)
	else
		puts "I don't know what you want to do. Exiting."
		exit(0)
	end
end

# fix so it shows the mapped currentMood instead of the number (git issue #2)
puts "You are currently in a #{currentMood} mood because '#{currentMoodReason}'."

entry = Mood.new currentMood, currentMoodReason, Time.now

diary.SaveEntry(entry)