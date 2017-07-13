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

	def online_at=(value)
		@online_at = value
	end

	def set_pending(message, to_call, parameters)
		pending[message.from.id] = {method: to_call, parameters: parameters}
	end

	def start(message, parameters)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(Bem vindo ao #{@@bot_name}!

Use /ajuda pra saber os comandos disponíveis!))
	end

	def registered_help(message, user)
		if(user.house == nil)
			chapeu_seletor = "\n/chapeu_seletor - Para fazer o teste que irá determinar a sua casa para a vida toda!"
		end
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(#{@@bot_name}

/ficha - Para mostrar sua ficha ou de outro usuário#{chapeu_seletor}))
	end

	def unregistered_help(message)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(#{@@bot_name}

/cadastrar - Para se cadastrar e usar meus comandos secretos ;\)))
	end

	def ajuda(message, parameters)
		user = User.find_by_id(message.from.id)
		if user == nil
			unregistered_help(message)
		else
			registered_help(message, user)
		end
	end

	def cadastrar(message, parameters)
		return unless check_private(message)

		if User.find_by_id(message.from.id) != nil
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Opa! Você já tem um cadastro! Usa /ficha pra ver :)')
			return
		end

		u = User.create(id: message.from.id, level: 1, handle: message.from.username)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ok! Quase lá. Como você gostaria de ser chamado? Quero dizer, qual é o seu nome?")
		set_pending(message, method(:set_name), nil)
	end

	def set_name(message, parameters)
		u = User.find_by_id(message.from.id)
		if u == nil
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Hm. Estranho. Fiquei confuso. Quer tentar de novo?')
			return
		end

		u.name = message.text
		u.save
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ok! De agora em diante vou te chamar de #{u.name}")
		ajuda(message, parameters)
	end

	def ficha(message, parameters)
		user = nil
		handle = nil
		if(parameters == nil) then
			user = User.find_by_id(message.from.id)
		else
			handle = parameters.split(" ").first
			handle = handle[1..-1] if handle[0] == '@'
			user = User.where('lower(handle) = ?', (handle.downcase)).first
		end

		if(user == nil) then
			if parameters == nil then
				@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ahhh. Você ainda não tem ficha comigo. Que tal se cadastrar?")
			else
				@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Não achei a ficha pra essa pessoa, #{handle}.")
			end
		else
			if(user.house != nil)
				house_message = "\nCasa: #{user.house.name}"
			else
				house_message = "\nO chapéu seletor ainda não determinou sua casa."
			end
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(Ficha de #{user.name}#{house_message}
Magia: #{user.level}))
		end
	end

	def check_private(message)
		if(message.chat.type != 'private')
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Hm, sabe o que é? Eu prefiro esse tipo de coisa no privado, se é que você me entende ;)')
			return false
		end
		true
	end

	def user_exists(message)
		user = User.find_by_id(message.from.id)
		if(user == nil) then
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Opa. Você precisa se cadastrar primeiro.')
			return false
		end
		true
	end

	def chapeu_seletor(message, parameters)
		return unless check_private(message)
		return unless user_exists(message)
		user = User.find_by_id(message.from.id)
		if(user.house != nil) then
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Desculpe, mas uma casa é pra vida toda, e você já é da #{user.house.name}")
			return
		end

		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Ok! O chapéu vai lhe fazer algumas perguntas, responda honestamente e lembre-se que não é possível voltar atrás.')

		selected = chapeu_seletor_pergunta(message, parameters, 1)

		set_pending(message, method(:chapeu_seletor_resposta), {question: 1, selected: selected, chances: {}})
	end

	def chapeu_seletor_pergunta(message, parameters, question_number)
		SortingHat.question(question_number, @bot, message, parameters)
	end

	def chapeu_seletor_resposta(message, parameters)
		chances = SortingHat.answer(parameters[:question], parameters[:selected], message.text, parameters[:chances])
		@bot.logger.warn(chances.to_s)
		if(chances == nil)
			@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Opa. Não, acho que você entendeu errado. Deixa eu te perguntar outra vez.')
			SortingHat.question_ask(parameters[:question], @bot, message, parameters[:selected])
			set_pending(message, method(:chapeu_seletor_resposta), {question: parameters[:question], selected: parameters[:selected], chances: parameters[:chances]})
			return
		end
		parameters[:question] = parameters[:question]+1
		parameters[:chances] = chances
		if(parameters[:question] > SortingHat.num_questions)
			return chapeu_seletor_resultado(message, parameters)
		end
		selected = SortingHat.question(parameters[:question], @bot, message, parameters)

		set_pending(message, method(:chapeu_seletor_resposta), {question: parameters[:question], selected: selected, chances: chances})
	end

	def chapeu_seletor_resultado(message, parameters)
		house = SortingHat.result(parameters[:chances])
		user = User.find_by_id(message.from.id)
		user.house_id = house[:id]
		user.save
		@bot.api.send_message(chat_id: message.chat.id, text: "O chapéu seletor pensa um pouco. E diz: \"#{house[:name]}!\" Seja bem-vindo!")
		@bot.api.send_message(chat_id: ENV['JOAKAROW_ID'], text: "Um novo aluno entra no grande salão e coloca o chapéu seletor. O chapéu seletor pensa um pouco e exclama: #{house[:name]}! Lhe desejo boas vindas, #{user.name_to_call}")
	end

	def puppeteer(message, parameters)
		if(message.from.id.to_s != ENV['MASTER_ID'])
			@bot.logger.error("Tentativa de puppeteer vinda do UID #{message.from.id}")
			return nao_implementado(message, parameters)
		end
		@bot.api.send_message(chat_id: ENV['JOAKAROW_ID'], text: parameters)
	end

	def online(message, parameters)
		@bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Tô aqui online desde #{@online_at.strftime("%H:%M de %d/%m/%Y")}.")
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
		command_handler.register('chapeu_seletor', method(:chapeu_seletor))
		command_handler.register('puppeteer', method(:puppeteer))
		command_handler.register('online', method(:online))
	end
end
