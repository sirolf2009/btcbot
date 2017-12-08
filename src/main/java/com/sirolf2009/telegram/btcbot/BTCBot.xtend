package com.sirolf2009.telegram.btcbot

import org.telegram.telegrambots.api.methods.send.SendMessage
import org.telegram.telegrambots.api.objects.Update
import org.telegram.telegrambots.bots.TelegramLongPollingBot
import org.telegram.telegrambots.exceptions.TelegramApiException

class BTCBot extends TelegramLongPollingBot {
	
	extension var Commands commands
	
	new() {
	}
	
	def setupCommands() {
		commands = new Commands(this)
	}

	override getBotToken() {
		"418604625:AAFaAc8xE-DEO6_Ek4yZZF6ZLyeAgYxqsUE"
	}

	override getBotUsername() {
		return "BTC_TRADING_BOT"
	}

	override onUpdateReceived(Update update) {
		commands.onMessageReceived(update).ifPresent[update.send(it)]
	}
	
	def void send(Update update, String msg) {
		send(update.message.chatId, msg)
	}
	
	def void send(Long chatID, String msg) {
		val message = new SendMessage().setChatId(chatID).setText(msg)
		try {
			sendMessage(message);
		} catch(TelegramApiException e) {
			e.printStackTrace();
		}
	}

}
