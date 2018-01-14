package com.sirolf2009.telegram.btcbot.command

import akka.actor.AbstractActor
import com.sirolf2009.util.akka.ActorHelper
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import java.io.File
import org.eclipse.xtend.lib.annotations.Data
import java.util.List
import java.nio.file.Files
import java.nio.charset.Charset
import akka.actor.ActorRef
import java.io.PrintWriter
import java.io.FileOutputStream

@FinalFieldsConstructor class SaveFileActor extends AbstractActor {
	
	extension val ActorHelper actorhelper = new ActorHelper(this)
	val ActorRef parent
	val File file
	
	override preStart() throws Exception {
		file.parentFile.mkdirs()
		file.createNewFile()
		parent.tell(getSavedContent(), self())
	}
	
	override createReceive() {
		receiveBuilder -> [
			match(GetSavedContent) [
				sender().tell(getSavedContent(), self())
			]
			match(WriteLine) [
				val writer = new PrintWriter(new FileOutputStream(file, true))
				writer.println(line)
				writer.close()
			]
			match(OverwriteContents) [
				val writer = new PrintWriter(new FileOutputStream(file, false))
				lines.forEach[
					writer.println(it)
				]
				writer.close()
			]
		]
	}
	
	def getSavedContent() {
		return new SavedContent(Files.readAllLines(file.toPath(), Charset.defaultCharset()))
	}
	
	@Data static class GetSavedContent {
	}
	@Data static class SavedContent {
		val List<String> lines
	}
	@Data static class WriteLine {
		val String line
	}
	@Data static class OverwriteContents {
		val List<String> lines
	}
	
}