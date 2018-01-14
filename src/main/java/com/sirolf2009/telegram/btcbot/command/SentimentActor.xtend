package com.sirolf2009.telegram.btcbot.command

import akka.actor.AbstractActor
import akka.actor.ActorRef
import com.google.gson.Gson
import com.sirolf2009.telegram.btcbot.ChatActor.CommandDescription
import com.sirolf2009.util.akka.ActorHelper
import java.net.URL
import java.nio.charset.Charset
import java.text.DecimalFormat
import java.time.Duration
import java.util.Optional
import org.apache.commons.io.IOUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtend.lib.annotations.ToString
import org.jsoup.Jsoup
import org.telegram.telegrambots.api.objects.Update

import static extension com.sirolf2009.telegram.btcbot.UpdateHelper.*
import java.util.stream.Stream
import com.sirolf2009.telegram.btcbot.ChatActor.ChatMessage

@FinalFieldsConstructor class SentimentActor extends AbstractActor {

	extension val ActorHelper actorhelper = new ActorHelper(this)

	val ActorRef chatActor

	override preStart() throws Exception {
		chatActor.tell(new CommandDescription("sentiment <symbol>", "Check the symbol's sentiment"), self())
	}

	override createReceive() {
		receiveBuilder -> [
			match(Update) [
				if(isCommand("sentiment")) {
					val symbol = param(1) 
					chatActor.tell(new ChatMessage(message.chatId, symbol.sentiment), self())
				}
			]
		]
	}
	
	def static getSentiment(String symbol) {
		Stream.of(symbol.investingSentiment, symbol.bfxDataSentiment).filter[isPresent].map[get].reduce[a,b| a+"\n"+b].orElse("Invalid symbol")
	}
	
	def static getInvestingSentiment(String symbol) {
		try {
			val url = new URL('''https://www.investing.com/currencies/«symbol.replace("/", "-").toLowerCase()»-technical''')
			val doc = Jsoup.parse(url, Duration.ofSeconds(10).toMillis as int)
			return Optional.of("Investing.com: "+doc.getElementsByClass("summary").get(0).children.get(0).text)
		} catch(Exception e) {
			return Optional.empty()
		}
	}
	
	def static getBfxDataSentiment(String symbol) {
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
