package com.sirolf2009.telegram.btcbot

import com.google.common.eventbus.Subscribe
import com.google.common.util.concurrent.AtomicDouble
import com.sirolf2009.bitfinex.wss.BitfinexWebsocketClient
import com.sirolf2009.bitfinex.wss.event.OnDisconnected
import com.sirolf2009.bitfinex.wss.model.SubscribeTrades
import com.sirolf2009.commonwealth.trading.ITrade
import java.io.File
import java.nio.file.Files
import java.time.Duration
import java.util.concurrent.atomic.AtomicBoolean
import org.eclipse.xtend.lib.annotations.Accessors
import com.sirolf2009.bitfinex.wss.event.OnSubscribed

class ATHFollower implements Runnable {

	@Accessors val AtomicDouble ath
	@Accessors val AtomicDouble current = new AtomicDouble()
	val BTCBot bot
	val long chatID
	val running = new AtomicBoolean(true)
	val File file = new File("ath")

	new(BTCBot bot, long chatID) {
		this.bot = bot
		this.chatID = chatID
		if(!file.exists()) {
			file.createNewFile()
			file.saveValue(20_000d)
			ath = new AtomicDouble(20_000)
		} else {
			ath = new AtomicDouble(file.savedValue)
		}
	}

	override run() {
		connect()
	}
	
	def void stop() {
		running.set(false)
	}

	@Subscribe def void onTrade(ITrade trade) {
		current.set(trade.price.doubleValue)
		if(running.get() && trade.price.doubleValue > ath.get()) {
			ath.set(trade.price.doubleValue)
			val file = new File("ath")
			if(System.currentTimeMillis() - file.lastModified > Duration.ofHours(1).toMillis()) {
				bot.send(chatID, "New all time high! "+trade.price)
				file.saveValue(trade.price.doubleValue())
			}
		}
	}

	@Subscribe def void onDisconnected(OnDisconnected onDisconnected) {
		if(running.get()) {
			connect()
		}
	}

	@Subscribe def void onSubscribed(OnSubscribed onSubscribed) {
		onSubscribed.eventBus.register(this)
	}

	def void connect() {
		val bitfinex = new BitfinexWebsocketClient()
		bitfinex.eventBus.register(this)
		bitfinex.connectBlocking()
		bitfinex.send(new SubscribeTrades("BTCUSD"))
	}

	def getSavedValue(File file) {
		try {
			return Double.parseDouble(Files.readAllLines(file.toPath).get(0))
		} catch(Exception e) {
			e.printStackTrace()
			return 20_000
		}
	}
	
	def saveValue(File file, Double value) {
		try {
			Files.write(file.toPath(), #[value+""])
		} catch(Exception e) {
			e.printStackTrace()
		}
	}

}
