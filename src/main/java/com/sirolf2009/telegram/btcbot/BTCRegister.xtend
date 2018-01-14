package com.sirolf2009.telegram.btcbot

import org.telegram.telegrambots.ApiContextInitializer
import org.telegram.telegrambots.TelegramBotsApi
import akka.actor.ActorSystem
import akka.actor.Props
import com.sirolf2009.telegram.btcbot.command.JokeActor
import com.sirolf2009.telegram.btcbot.command.HelpActor
import com.sirolf2009.telegram.btcbot.command.RSSCoinTelegraphActor
import com.sirolf2009.telegram.btcbot.command.SentimentActor

class BTCRegister {
	
	def static void main(String[] args) {
		ApiContextInitializer.init()
		val api = new TelegramBotsApi()
		val bot = new BTCBot()
		bot.setupCommands()
		api.registerBot(bot)
		
		val system = ActorSystem.apply("btc-bot")
		val chatActor = system.actorOf(Props.create(ChatActor, [new ChatActor(bot)]))
		val helpCommand = system.actorOf(Props.create(HelpActor, [new HelpActor(chatActor)]), "command-help")
		val jokeCommand = system.actorOf(Props.create(JokeActor, [new JokeActor(chatActor)]), "command-joke")
		val sentimentCommand = system.actorOf(Props.create(SentimentActor, [new SentimentActor(chatActor)]), "command-sentiment")
		val rssCommand = system.actorOf(Props.create(RSSCoinTelegraphActor, [new RSSCoinTelegraphActor(chatActor)]), "rss-cointelegaph")
		
		bot.addListener[
			helpCommand.tell(it, chatActor)
			jokeCommand.tell(it, chatActor)
			sentimentCommand.tell(it, chatActor)
			rssCommand.tell(it, chatActor)
		]
	}
	
}