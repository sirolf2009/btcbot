package com.sirolf2009.telegram.btcbot.command

import akka.actor.AbstractActor
import akka.actor.ActorRef
import akka.pattern.Patterns
import akka.util.Timeout
import com.sirolf2009.telegram.btcbot.ChatActor.ChatMessage
import com.sirolf2009.telegram.btcbot.ChatActor.CommandDescription
import com.sirolf2009.telegram.btcbot.ChatActor.CommandDescriptions
import com.sirolf2009.telegram.btcbot.ChatActor.GetCommandDescriptions
import com.sirolf2009.util.akka.ActorHelper
import java.util.concurrent.TimeUnit
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.telegram.telegrambots.api.objects.Update
import scala.concurrent.Await
import scala.concurrent.duration.Duration

import static extension com.sirolf2009.telegram.btcbot.UpdateHelper.*

@FinalFieldsConstructor class HelpActor extends AbstractActor {
	
	extension val ActorHelper actorhelper = new ActorHelper(this)
	val ActorRef chatActor
	
	override preStart() throws Exception {
		chatActor.tell(new CommandDescription("help", "Display this message"), self())
	}
	
	override createReceive() {
		receiveBuilder -> [
			match(Update) [
				if(isMessage("help")) {
					val commands = Await.result(Patterns.ask(chatActor, new GetCommandDescriptions(), new Timeout(Duration.create(10, TimeUnit.SECONDS))), Duration.create(10, TimeUnit.SECONDS)) as CommandDescriptions
					chatActor.tell(new ChatMessage(message.chatId, commands.commands.map['''«command»: «description»'''].join("\n")), self())
				}
			]
		]
	}
	
}