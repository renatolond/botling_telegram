require 'telegram/bot'
require './environment'

bot_name = "Botling (Telegram Delivery Bot version - Alpha)"
online_at = Time.now

logger = Logger.new('botling.log')

def ficha(message, bot, parameters)
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
			bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ahhh. Você ainda não tem ficha comigo. Que tal se cadastrar?")
		else
			bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Não achei a ficha pra essa pessoa, #{handle}.")
		end
	else
		bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Ficha de #{user.name}")
	end
end

Telegram::Bot::Client.run(ENV['BOT_TOKEN'], logger: logger) do |bot|
	bot.listen do |message|
		command, parameters = message.text.split(" ", 2)
		begin
			case command
				when '/start'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(Bem vindo ao #{bot_name}!

Use /ajuda pra saber os comandos disponíveis!))
				when '/ajuda'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: %Q(#{bot_name}

/ficha - Para mostrar sua ficha ou de outro usuário))
				when '/ficha'
					ficha(message, bot, parameters)
				when '/online'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Tô aqui online desde #{online_at.strftime("%H:%M de %d/%m/%Y")}.")
				when '/caldeirao_furado'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Os elfos ainda não implementaram esse comando. :(')
				when '/duelos'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Os elfos ainda não implementaram esse comando. :(')
				when '/animais'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Os elfos ainda não implementaram esse comando. :(')
				when '/rank'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Os elfos ainda não implementaram esse comando. :(')
				when '/gringotes'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: 'Os elfos ainda não implementaram esse comando. :(')
			end
		rescue => e
			logger.error "Something went wrong! #{e}"
		end
	end
end
