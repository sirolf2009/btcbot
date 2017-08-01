package com.sirolf2009.telegram.btcbot.command

import org.junit.Test

class TestCommandArbritrage {
	
	@Test
	def void test() {
		
		//BTC->USD rate: 2735.02 1.0 BTC -> 2735.02 USD
		//USD->LTC rate: 0.02127659574468085 2735.02 USD -> 58.19191489361702 LTC
		//LTC->BTC rate: 0.01723999 58.19191489361702 LTC -> 1.0032280308468084 BTC
		//Profit: 0.0032280308468084495
		
		val prices = #{
			"BTC/USD" -> 2735.02d,
			"LTC/USD" -> 47d,
			"LTC/BTC" -> 0.01723999d
		}
		println(CommandArbritrage.getArbritrage(prices, #["BTC", "USD", "LTC", "BTC"]))
		println(CommandArbritrage.getArbritrage(prices, #["BTC", "LTC", "USD", "BTC"]))
	}
	
}