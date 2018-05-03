class Diary
	attr_accessor :entries
	attr_accessor :moods

	FILENAME = "moodDiary.txt".freeze
	private_constant = :FILENAME

	def initialize

        @moods = { 1 => "Terrible", 2 => "Bad", 3 => "Okay", 4 => "Good", 5 => "Great" }

		# check to see if the file exists
		if File.file? FILENAME
			# load the entries from the file
			@entries = load_entries(FILENAME)
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
			load_entries(FILENAME)
		rescue IOError => e
			puts e
		ensure
			diary.close unless diary.nil?
		end
	end

	# does this belong here?
	def get_scale
        scale = "Moods:\n"
        @moods.each do |k,v| 
            scale << "#{k} = #{v}\n"
        end
        scale  
	end

	private

	def load_entries(filename)
		results = []
		File.foreach(filename) do |l|
			# parse each line since it's tab-delimited

			# this could all be cleaner!
			ts, m, r = l.split(/\t/)
			entry = Mood.new
			entry.timestamp = ts
			entry.mood = m
			entry.reason = r

			results.push(entry)
		end
		results
	end
end
