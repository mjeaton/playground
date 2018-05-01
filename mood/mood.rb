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
		"Mood scale: 1=Blah, 2=Meh, 3=Ok, 4=Good, 5=Great"
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

def Prompt
	puts diary.GetMoodScale 
	puts "What's your mood right now?"
	currentMood = gets.chomp.to_i

	puts "Why?"
	currentMoodReason = gets.chomp
end

diary = Diary.new

if ARGV.count == 0
	Prompt
elsif ARGV.count == 1
	# look into an Options parser lib
	if ARGV[0] == "/reset"
		puts "Are you sure you want to clear the diary? (y/N)"
		answer = gets.chomp

		if(answer == "" || answer == 'N' || answer == 'n')
			puts "Ok, NOT clearing the diary this time."
		else
			diary.Clear
			exit(0)
		end
	end
end

puts "Current mood: #{currentMood}."
puts "Reason: #{currentMoodReason}."

entry = Mood.new currentMood, currentMoodReason, Time.now

diary.SaveEntry(entry)