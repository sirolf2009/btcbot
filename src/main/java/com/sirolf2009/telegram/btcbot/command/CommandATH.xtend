package com.sirolf2009.telegram.btcbot.command

import com.sirolf2009.telegram.btcbot.ATHFollower
import com.sirolf2009.telegram.btcbot.BTCBot
import java.io.File
import java.io.FileWriter
import java.io.PrintWriter
import java.nio.file.Files
import java.util.HashMap
import java.util.Map

class CommandATH extends Command {

	static val Map<Long, ATHFollower> followers = new HashMap()
	static val followersFile = new File("ath-follower")

	new(BTCBot bot) {
		super("ath", "<enable|disable|status|dump|current>", "ATH feed") [
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
						return followers.get(chatID).ath.get()+""
					} else {
						return "This chat is not registered"
					}
				} else if(params.get(1).equals("current")) {
					if(chatID.registered()) {
						return followers.get(chatID).current.get()+""
					} else {
						return "This chat is not registered"
					}
				} else {
					return "Illegal argument"
				}
			} else {
				return "Usage: ath <enable|disable|status|dump>"
			}
		]
		savedIDs.forEach [
			bot.register(it)
		]
	}

	def static registered(Long chatID) {
		return followers.containsKey(chatID)
	}

	def static register(BTCBot bot, Long chatID) {
		val follower = new ATHFollower(bot, chatID)
		new Thread(follower).start()
		followers.put(chatID, follower)
		save()
	}

	def static unregister(BTCBot bot, Long chatID) {
		followers.get(chatID).stop()
		followers.remove(chatID)
		save()
	}

	def static getSavedIDs() {
		followersFile.createNewFile
		Files.readAllLines(followersFile.toPath).map [
			try {
				return Long.parseLong(it)
			} catch(Exception e) {
				System.err.println("Failed to parse " + it)
				e.printStackTrace()
				return null
			}
		].filter[it !== null]
	}

	def static save() {
		followersFile.createNewFile
		val writer = new PrintWriter(new FileWriter(followersFile))
		writer.println(followers.keySet.map[toString].join("\n"))
		writer.close()
	}
}
