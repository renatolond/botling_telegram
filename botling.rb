require 'telegram/bot'

bot_name = "Botling Telegram Delivery Bot (Alpha)"

Telegram::Bot::Client.run(ENV['BOT_TOKEN']) do |bot|
	bot.listen do |message|
		case message.text
			when '/start'
				bot.api.send_message(chat_id: message.chat.id, text: "Bem vindo ao #{bot_name}!\nUse /ajuda pra saber os comandos disponíveis!")
			when '/ajuda'
				bot.api.send_message(chat_id: message.chat.id, text: "#{bot_name}")
		end
	end
end
