require 'telegram_bot'

bot = TelegramBot.new(token: ENV['BOT_TOKEN'])
bot.get_updates(fail_silently: true) do |message|
	puts "@#{message.from.username}: #{message.text}"
	command = message.get_command_for(bot)

	message.reply do |reply|
		case command
		when /ajuda/i
			reply.text = "Botling Telegram Delivery bot (ALPHA)"
		end
		puts "sending #{reply.text.inspect} to @#{message.from.username}"
		reply.send_with(bot)
	end
end
