class Mood
	attr_accessor :Mood
	attr_accessor :Reason
	attr_accessor :Timestamp
end

def writeEntry(diary, entry)
	diary.puts "=" * 10
	diary.puts entry.Timestamp 
	diary.puts entry.Mood 
	diary.puts entry.Reason 
end

puts "Mood scale: 1=Blah, 2=Meh, 3=Ok, 4=Good, 5=Great"
puts "What's your mood right now?"
currentMood = gets.chomp.to_i

puts "Why?"
currentMoodReason = gets.chomp

puts "Current mood: #{currentMood}."
puts "Reason: #{currentMoodReason}."

entry = Mood.new
entry.Mood = currentMood
entry.Reason = currentMoodReason
entry.Timestamp = Time.now

begin
	moodDiary = File.open("moodDiary.txt", "a") 
	writeEntry(moodDiary, entry)
rescue IOError => e
	puts e
ensure
	moodDiary.close unless moodDiary.nil?
end
