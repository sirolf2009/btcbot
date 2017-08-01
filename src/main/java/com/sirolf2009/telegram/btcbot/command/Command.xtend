package com.sirolf2009.telegram.btcbot.command

import org.eclipse.xtend.lib.annotations.Data
import org.telegram.telegrambots.api.objects.Update

@Data class Command {
	
	val String name
	val String params
	val String description
	val (Update)=>String action
	
}