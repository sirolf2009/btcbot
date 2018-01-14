package com.sirolf2009.telegram.btcbot

import java.util.ArrayList
import java.util.function.Consumer
import org.telegram.telegrambots.api.methods.send.SendMessage
import org.telegram.telegrambots.api.objects.Update
import org.telegram.telegrambots.bots.TelegramLongPollingBot
import org.telegram.telegrambots.exceptions.TelegramApiException

class BTCBot extends TelegramLongPollingBot {
	
	val listeners = new ArrayList<Consumer<Update>>()
	
	new() {
	}
	
	def setupCommands() {
	}
	
	def addListener(Consumer<Update> consumer) {
		listeners.add(consumer)
	}

	override getBotToken() {
		"418604625:AAFaAc8xE-DEO6_Ek4yZZF6ZLyeAgYxqsUE"
	}

	override getBotUsername() {
		return "BTC_TRADING_BOT"
	}

	override onUpdateReceived(Update update) {
		listeners.parallelStream.forEach[accept(update)]
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
