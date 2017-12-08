package com.sirolf2009.telegram.btcbot

import com.rometools.rome.io.SyndFeedInput
import com.rometools.rome.io.XmlReader
import java.net.URL
import java.util.concurrent.atomic.AtomicBoolean
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@FinalFieldsConstructor class RSSFollower implements Runnable {
	
	val BTCBot bot
	val long chatID
	val running = new AtomicBoolean(true)

	override run() {
		val known = uris.toSet()
		while(running.get()) {
			try {
				uris.forEach [
					if(known.add(it)) {
						bot.send(chatID, it)
					}
				]
				Thread.sleep(10000)
			} catch(Exception e) {
				e.printStackTrace()
			}
		}
	}

	def getUris() {
		val input = new SyndFeedInput()
		val feed = input.build(new XmlReader(new URL("https://cointelegraph.com/rss")))
		feed.entries.map[uri]
	}
	
	def stop() {
		running.set(false)
	}

}
