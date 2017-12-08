package com.sirolf2009.telegram.btcbot.command

import com.google.gson.Gson
import java.net.URL
import java.nio.charset.Charset
import java.text.DecimalFormat
import java.time.Duration
import java.util.Optional
import java.util.stream.Stream
import org.apache.commons.io.IOUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString
import org.jsoup.Jsoup

class CommandSentiment extends Command {

	new() {
		super("sentiment", "<symbol>", "Get the symbols sentiment") [
			val params = message.text.split(" ")
			if(params.size == 2) {
				return Stream.of(params.get(1).bfxDataSentimentForSymbol, params.get(1).investingSentimentForSymbol).filter[isPresent].map[get].reduce[a,b|a+"\n"+b].orElse("Not a valid symbol: "+params.get(1))
			}
		]
	}

	def static getInvestingSentimentForSymbol(String symbol) {
		try {
			val url = new URL('''https://www.investing.com/currencies/«symbol.replace("/", "-").toLowerCase()»-technical''')
			val doc = Jsoup.parse(url, Duration.ofSeconds(10).toMillis as int)
			return Optional.of("Investing.com: "+doc.getElementsByClass("summary").get(0).children.get(0).text)
		} catch(Exception e) {
			return Optional.empty()
		}
	}
	
	def static getBfxDataSentimentForSymbol(String symbol) {
		try {
			val url = new URL('''https://bfxdata.com/json/sellBuyVolumes1h«symbol.replace("/", "").toUpperCase()».json''')
			val it = new Gson().fromJson(IOUtils.toString(url, Charset.defaultCharset()), SellBuyVolumes1H)
			val format = new DecimalFormat("##0.##")
			if(sell > buy) {
				return Optional.of('''BFXData: sell «format.format(sell/(total)*100)»%''')
			}
			return Optional.of('''BFXData.com: buy «format.format(buy/(total)*100)»%''')
		} catch(Exception e) {
			return Optional.empty()
		}
	}
	
	@Accessors @ToString static class SellBuyVolumes1H {
		
		private double Sell
		private double Buy
		private double Total
		
	} 

}
