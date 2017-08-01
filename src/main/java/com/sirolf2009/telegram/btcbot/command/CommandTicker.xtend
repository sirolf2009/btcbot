package com.sirolf2009.telegram.btcbot.command

import com.sirolf2009.telegram.btcbot.Database

class CommandTicker extends Command {
	
	new(extension Database database) {
		super("ticker", "<symbol>", "Get the latest price for a symbol") [
			val params = message.text.split(" ")
			if(params.size == 2) {
				try {
					return getLastTrade(params.get(1).toUpperCase)
				} catch(NullPointerException e) {
					return "Invalid pair: " + params.get(1).toUpperCase
				}
			} else {
				return "Expected ticker <pair>"
			}
		]
	}
	
}