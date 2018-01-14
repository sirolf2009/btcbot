package com.sirolf2009.telegram.btcbot

import org.telegram.telegrambots.api.objects.Update

class UpdateHelper {
	
	def static boolean isMessage(Update update, String message) {
		if(update.hasMessage() && update.getMessage().hasText()) {
			return update.message.text.equalsIgnoreCase(message)
		}
	}
	
	def static boolean isCommand(Update update, String command) {
		if(update.hasMessage() && update.getMessage().hasText()) {
			return update.message.text.toLowerCase().startsWith(command.toLowerCase())
		}
	}
	
	def static String param(Update update, int index) {
		if(update.hasMessage() && update.getMessage().hasText()) {
			val data = update.message.text.split(" ")
			return data.get(index)
		}
	}
	
}