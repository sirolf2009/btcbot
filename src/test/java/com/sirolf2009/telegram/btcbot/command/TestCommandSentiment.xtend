package com.sirolf2009.telegram.btcbot.command

import org.junit.Test

class TestCommandSentiment {
	
	@Test
	def void test() {
		println(CommandSentiment.getInvestingSentimentForSymbol("BTC/USD"))
		println(CommandSentiment.getBfxDataSentimentForSymbol("BTC/USD"))
	}
	
}