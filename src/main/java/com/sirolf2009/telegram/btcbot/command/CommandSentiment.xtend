package com.sirolf2009.telegram.btcbot.command

import java.net.URL
import java.net.MalformedURLException
import org.jsoup.Jsoup
import java.time.Duration

class CommandSentiment extends Command {

	new() {
		super("sentiment", "<symbol>", "Get the investing.com sentiment") [
			val params = message.text.split(" ")
			if(params.size == 2) {
				return params.get(1).sentimentForSymbol
			}
		]
	}

	def static String getSentimentForSymbol(String symbol) {
		try {
			val url = new URL('''https://www.investing.com/currencies/«symbol.replace("/", "-").toLowerCase()»-technical''')
			val doc = Jsoup.parse(url, Duration.ofSeconds(10).toMillis as int)
			return doc.getElementsByClass("summary").get(0).children.get(0).text
		} catch(MalformedURLException e) {
			return '''«symbol» is not a valid symbol'''
		}
	}

}
