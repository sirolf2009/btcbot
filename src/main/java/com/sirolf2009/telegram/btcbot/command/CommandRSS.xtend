package com.sirolf2009.telegram.btcbot.command

import com.sirolf2009.telegram.btcbot.BTCBot
import com.sirolf2009.telegram.btcbot.RSSFollower
import java.util.HashMap
import java.util.Map
import java.io.PrintWriter
import java.io.FileWriter
import java.nio.file.Files
import java.nio.file.Paths

class CommandRSS extends Command {
	
	static val Map<Long, RSSFollower> followers = new HashMap()

	new(BTCBot bot) {
		super("rss", "<enable|disable|status|dump>", "RSS feed") [
			val chatID = it.message.chatId
			val params = message.text.split(" ")
			if(params.size == 2) {
				if(params.get(1).equals("enable")) {
					if(chatID.registered()) {
						return "This room is already registered"
					} else {
						bot.register(chatID)
						return "Success!"
					}
				} else if(params.get(1).equals("disable")) {
					if(chatID.registered()) {
						bot.unregister(chatID)
						return "Success!"
					} else {
						return "This chat is not registered"
					}
				} else if(params.get(1).equals("status")) {
					if(chatID.registered()) {
						return "This chat is registered"
					} else {
						return "This chat is not registered"
					}
				} else if(params.get(1).equals("dump")) {
					if(chatID.registered()) {
						return followers.get(chatID).uris.join("\n")
					} else {
						return "This chat is not registered"
					}
				} else {
					return "Illegal argument"
				}
			} else {
				return "Usage: rss <enable|disable>"
			}
		]
		savedIDs.forEach[
			bot.register(it)
		]
	}
	
	def static registered(Long chatID) {
		return followers.containsKey(chatID)
	}
	
	def static register(BTCBot bot, Long chatID) {
		val follower = new RSSFollower(bot, chatID)
		new Thread(follower).start()
		followers.put(chatID, follower)
		val writer = new PrintWriter(new FileWriter("rss", true))
		writer.println(chatID)
		writer.close()
	}
	
	def static getSavedIDs() {
		Files.readAllLines(Paths.get("rss")).map[
			try {
				return Long.parseLong(it)
			} catch(Exception e) {
				System.err.println("Failed to parse "+it)
				e.printStackTrace()
				return null
			}
		].filter[it !== null]
	}
	
	def static unregister(BTCBot bot, Long chatID) {
		followers.get(chatID).stop()
		followers.remove(chatID)
	}
	
}