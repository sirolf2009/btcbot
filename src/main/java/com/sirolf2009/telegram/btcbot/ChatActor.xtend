package com.sirolf2009.telegram.btcbot

import akka.actor.AbstractActor
import com.sirolf2009.util.akka.ActorHelper
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@FinalFieldsConstructor class ChatActor extends AbstractActor {
	
	extension val ActorHelper actorhelper = new ActorHelper(this)
	val BTCBot bot
	val commands = new ArrayList<CommandDescription>()
	
	override createReceive() {
		receiveBuilder -> [
			match(ChatMessage) [
				bot.send(chatID, text)
			]
			match(CommandDescription) [
				commands.add(it)
			]
			match(GetCommandDescriptions) [
				sender().tell(new CommandDescriptions(commands), self())
			]
		]
	}
	
	@Data static class ChatMessage {
		val Long chatID
		val String text
	}
	
	@Data static class CommandDescription {
		val String command
		val String description
	}
	
	@Data static class CommandDescriptions {
		val List<CommandDescription> commands
	}
	@Data static class GetCommandDescriptions {
	}
	
}