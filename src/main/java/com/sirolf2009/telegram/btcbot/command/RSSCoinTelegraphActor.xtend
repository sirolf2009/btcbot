package com.sirolf2009.telegram.btcbot.command

import akka.actor.AbstractActor
import akka.actor.ActorRef
import akka.actor.Props
import com.sirolf2009.telegram.btcbot.ChatActor.ChatMessage
import com.sirolf2009.telegram.btcbot.ChatActor.CommandDescription
import com.sirolf2009.telegram.btcbot.command.RSSActor.NewURI
import com.sirolf2009.telegram.btcbot.command.SaveFileActor.OverwriteContents
import com.sirolf2009.telegram.btcbot.command.SaveFileActor.SavedContent
import com.sirolf2009.telegram.btcbot.command.SaveFileActor.WriteLine
import com.sirolf2009.util.akka.ActorHelper
import java.io.File
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.telegram.telegrambots.api.objects.Update

import static extension com.sirolf2009.telegram.btcbot.UpdateHelper.*

@FinalFieldsConstructor class RSSCoinTelegraphActor extends AbstractActor {

	extension val ActorHelper actorhelper = new ActorHelper(this)

	val ActorRef chatActor
	val roomFileActor = getContext().actorOf(Props.create(SaveFileActor, [new SaveFileActor(self(), new File("rss/rss-cointelegraph"))]), "rooms")
	val Set<Long> roomIDs = new HashSet()

	override preStart() throws Exception {
		chatActor.tell(new CommandDescription("rss <enable|disable>", "Follow cointelegraph articles"), self())
		getContext().actorOf(Props.create(RSSActor, [new RSSActor(self(), "https://cointelegraph.com/rss")]), "rss")
	}

	override createReceive() {
		receiveBuilder -> [
			match(SavedContent) [
				lines.map[Long.parseLong(it)].forEach [
					roomIDs.add(it)
				]
			]
			match(NewURI) [
				roomIDs.forEach [ room |
					chatActor.tell(new ChatMessage(room, uri), self())
				]
			]
			match(Update) [
				if(isMessage("rss enable")) {
					if(roomIDs.add(message.chatId)) {
						roomFileActor.tell(new WriteLine(message.chatId.toString()), self())
					}
				} else if(isMessage("rss disable")) {
					if(roomIDs.remove(message.chatId)) {
						roomFileActor.tell(new OverwriteContents(roomIDs.map[toString()].toList()), self())
					}
				}
			]
		]
	}

}
