class CommandHandler
	def initialize(bot_nickname)
		@bot_nickname_str = "@#{bot_nickname}"
		@commands = {}
	end

	def register(command, code)
		@commands[command] = code
	end

	def handle(command, parameters, message)
		return false if(command[0] != '/')

		command = command[1..-1]

		if command[-@bot_nickname_str.size..-1] == @bot_nickname_str
			command = command[0..-@bot_nickname_str.size-1]
		end
		p command
		to_call = @commands[command]
		@commands[command].call(message, parameters) unless to_call == nil
	end
end
