package com.sirolf2009.telegram.btcbot.command

import com.sirolf2009.telegram.btcbot.Alerts

class CommandAlerts extends Command {

	new(extension Alerts alerts) {
		super("alert", "<enable|disable|status>", "Edit alerts for price movements") [
			val params = message.text.split(" ")
			if(params.size == 4 && params.get(1).equals("enable")) {
				val symbol = params.get(2).toUpperCase
				val diff = Double.parseDouble(params.get(3))
				addAlert(symbol, message.chatId, diff)
				return "alert has been added for " + symbol + " for this room"
			} else if(params.size == 4 && params.get(1).equals("disable")) {
				val symbol = params.get(2).toUpperCase
				val diff = Double.parseDouble(params.get(3))
				return removeAlert(symbol, diff, message.chatId).map['''Alert for «symbol» with difference «difference» has been removed'''].reduce[a, b|a + "\n" + b]
			} else if(params.size == 3 && params.get(1).equals("disable")) {
				val symbol = params.get(2).toUpperCase
				return removeAlert(symbol, message.chatId).map['''Alert for «symbol» with difference «difference» has been removed'''].reduce[a, b|a + "\n" + b]
			} else if(params.size == 2 && params.get(1).equals("status")) {
				val room = message.chatId
				val alertsForRoom = room.alerts
				if(alertsForRoom.isEmpty) {
					return "No alerts are enabled for this room"
				} else {
					return room.alerts.map['''«symbol»: «difference as float»% from «previousMilestone». Lower=«targets.key.floatValue» Upper=«targets.value.floatValue»'''].reduce[a, b|a + "\n" + b]
				}
			} else {
				return "Expected alerts <command>"
			}
		]
	}

}
