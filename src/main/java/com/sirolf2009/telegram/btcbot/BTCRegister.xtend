package com.sirolf2009.telegram.btcbot

import org.telegram.telegrambots.ApiContextInitializer
import org.telegram.telegrambots.TelegramBotsApi

class BTCRegister {
	
	def static void main(String[] args) {
		ApiContextInitializer.init()
		val api = new TelegramBotsApi()
		api.registerBot(new BTCBot());
	}
	
}