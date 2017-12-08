package com.sirolf2009.telegram.btcbot

import com.sirolf2009.telegram.btcbot.command.Command
import com.sirolf2009.telegram.btcbot.command.CommandJoke
import com.sirolf2009.telegram.btcbot.command.CommandRSS
import com.sirolf2009.telegram.btcbot.command.CommandSentiment
import java.util.List
import java.util.Optional
import org.eclipse.xtend.lib.annotations.Accessors
import org.telegram.telegrambots.api.objects.Update

@Accessors
class Commands {

	val enabledAlerts = newArrayList()
	val List<Command> commands

	new(BTCBot bot) {
		commands = #[
			new CommandJoke(),
			new CommandSentiment(),
			new CommandRSS(bot)
		]
	}

	def onMessageReceived(Update update) {
		if(update.hasMessage() && update.getMessage().hasText()) {
			if(update.getMessage().text.equalsIgnoreCase("help")) {
				return Optional.of(commands.map['''«name» «params» «description»'''].reduce[a,b|a+"\n"+b])
			} else {
				val command = update.getMessage().text.command
				return Optional.ofNullable(commands.findFirst[candidate|candidate.name.equals(command)]).map [
					action.apply(update)
				]
			}
		}
		return Optional.empty
	}

	def String getCommand(String text) {
		val lower = text.toLowerCase()
		if(lower.contains(" ")) {
			return lower.split(" ").get(0)
		} else {
			return lower
		}
	}

}
