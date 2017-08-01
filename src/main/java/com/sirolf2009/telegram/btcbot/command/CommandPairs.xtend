package com.sirolf2009.telegram.btcbot.command

import com.sirolf2009.telegram.btcbot.Database

class CommandPairs extends Command {
	
	new(extension Database database) {
		super("pairs", "", "Show all ticker pairs") [
			getPairs().reduce[a, b|a + ", " + b]
		]
	}
	
}