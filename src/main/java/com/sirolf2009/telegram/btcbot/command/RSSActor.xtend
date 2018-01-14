package com.sirolf2009.telegram.btcbot.command

import akka.actor.AbstractActor
import akka.actor.ActorRef
import com.rometools.rome.io.SyndFeedInput
import com.rometools.rome.io.XmlReader
import com.sirolf2009.util.akka.ActorHelper
import java.net.URL
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Data

class RSSActor extends AbstractActor {

	extension val ActorHelper actorhelper = new ActorHelper(this)
	val ActorRef parent
	val String url
	val Set<String> known
	
	new(ActorRef parent, String url) {
		this.parent = parent
		this.url = url
		known = getUris(url)
		known.forEach[
			println("known: "+it)
		]
	}

	override preStart() throws Exception {
		new Thread [
			try {
				Thread.sleep(10000)
				getUris(url).forEach [
					if(known.add(it)) {
						println("new: "+it)
						parent.tell(new NewURI(it), self())
					}
				]
			} catch(Exception e) {
				e.printStackTrace()
			}
		].start()
	}

	override createReceive() {
		receiveBuilder -> []
	}

	def getUris(String url) {
		val input = new SyndFeedInput()
		val feed = input.build(new XmlReader(new URL(url)))
		new HashSet(feed.entries.map[uri].toSet())
	}
	
	@Data static class NewURI {
		String uri
	}

}
