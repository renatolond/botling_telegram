class Botling
	@@bot_name = "Botling (Telegram Delivery Bot version - Alpha)"
	@@bot_nickname = "botling_bot"

	attr_reader :pending
	def initialize
		@pending = {}
	end

	def bot_nickname
		@@bot_nickname
	end

	def bot=(value)
		@bot = value
	end

	def start(message, parameters)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(Bem vindo ao #{@@bot_name}!

Use /ajuda pra saber os comandos disponíveis!))
	end

	def ajuda(message, parameters)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(#{@@bot_name}

/ficha - Para mostrar sua ficha ou de outro usuário))
	end

	def ficha(message, parameters)
		user = nil
		handle = nil
		if(parameters == nil) then
			user = User.find_by_id(message.from.id)
		else
			handle = parameters.split(" ").first
			user = User.find_by_handle(handle)
		end

		if(user == nil) then
			if parameters == nil then
				@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ahhh. Você ainda não tem ficha comigo. Que tal se cadastrar?")
			else
				@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Não achei a ficha pra essa pessoa, #{handle}.")
			end
		else
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ficha de #{user.name}")
		end
	end

	def nao_implementado(message, parameters)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Os elfos ainda não implementaram esse comando. :(')
	end

	def register_commands(command_handler)
		command_handler.register('start', method(:start))
		command_handler.register('ajuda', method(:ajuda))
		command_handler.register('ficha', method(:ficha))
		command_handler.register('caldeirao_furado', method(:nao_implementado))
		command_handler.register('duelos', method(:nao_implementado))
		command_handler.register('animais', method(:nao_implementado))
		command_handler.register('rank', method(:nao_implementado))
		command_handler.register('gringotes', method(:nao_implementado))
	end
end
