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

	# does this belong here?
	def GetMoodScale 
		"Mood scale: 1=Terrible, 2=Bad, 3=Okay, 4=Good, 5=Great"
	end
end

class Mood
	attr_accessor :Mood
	attr_accessor :Reason
	attr_accessor :Timestamp
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
	# some of this feels dirty and not very Ruby-like
	# also, the multiple exits(0) really bother me.1

	# look into an Options parser lib
	if ARGV[0] == "--reset"
		puts "Are you sure you want to clear the diary? (y/N)"
		answer = STDIN.gets.chomp

		if(["y", "Y"].include? answer)
			diary.Clear
			puts "Diary has been cleared."
		else
			puts "Ok, NOT clearing the diary this time."
		end
		exit(0)
	else
		puts "I don't know what you want to do. Exiting."
		exit(0)
	end
end