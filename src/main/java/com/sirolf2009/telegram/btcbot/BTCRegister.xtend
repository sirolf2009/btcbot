package com.sirolf2009.telegram.btcbot

import org.telegram.telegrambots.ApiContextInitializer
import org.telegram.telegrambots.TelegramBotsApi

class BTCRegister {
	
	def static void main(String[] args) {
		ApiContextInitializer.init()
		val api = new TelegramBotsApi()
		val bot = new BTCBot()
		bot.setupCommands()
		api.registerBot(bot)
	}
	
}