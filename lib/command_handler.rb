class CommandHandler
	def initialize(bot_nickname)
		@bot_nickname_str = "@#{bot_nickname}"
		@commands = {}
	end

	def register(command, code)
		@commands[command] = code
	end

	def bot=(value)
		@bot = value
	end

	def handle(command, parameters, message)
		return false if(command[0] != '/')

		command = command[1..-1]

		if command[-@bot_nickname_str.size..-1] == @bot_nickname_str
			command = command[0..-@bot_nickname_str.size-1]
		end
		to_call = @commands[command]
		if to_call
			@commands[command].call(message, parameters)
		else
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Oops. I don't know that one.")
		end
	end
end
