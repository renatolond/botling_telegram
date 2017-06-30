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

	def registered_help(message)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(#{@@bot_name}

/ficha - Para mostrar sua ficha ou de outro usuário))
	end

	def unregistered_help(message)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(#{@@bot_name}

/cadastrar - Para se cadastrar e usar meus comandos secretos ;\)))
	end

	def ajuda(message, parameters)
		if User.find_by_id(message.from.id) == nil
			unregistered_help(message)
		else
			registered_help(message)
		end
	end

	def cadastrar(message, parameters)
		if User.find_by_id(message.from.id) != nil
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Opa! Você já tem um cadastro! Usa /ficha pra ver :)')
			return
		end

		u = User.create(id: message.from.id, level: 1, handle: message.from.username)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ok! Quase lá. Como você gostaria de ser chamado? Quero dizer, qual é o seu nome?")
		pending[message.from.id] = method(:set_name)
	end

	def set_name(message, parameters)
		u = User.find_by_id(message.from.id)
		if u == nil
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Hm. Estranho. Fiquei confuso. Quer tentar de novo?')
			return
		end

		u.name = message.text
		u.save
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ok! De agora em diante você vai ser chamado de #{u.name}")
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
		command_handler.register('cadastrar', method(:cadastrar))
	end
end
