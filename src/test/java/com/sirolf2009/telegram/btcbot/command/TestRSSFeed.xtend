package com.sirolf2009.telegram.btcbot.command

import org.junit.Test
import com.rometools.rome.io.SyndFeedInput
import com.rometools.rome.io.XmlReader
import java.net.URL

class TestRSSFeed {
	
	@Test
	def void test() {
		val input = new SyndFeedInput()
		val feed = input.build(new XmlReader(new URL("https://cointelegraph.com/rss")))
		feed.entries.forEach[
			println("entry: "+it.uri)
		]
	}
	
}