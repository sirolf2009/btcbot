package com.sirolf2009.telegram.btcbot

import java.io.File
import java.io.FileOutputStream
import java.io.PrintWriter
import java.nio.file.Files
import java.util.Arrays
import java.util.List
import java.util.function.Consumer
import java.util.stream.Collectors
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

class Alerts implements Runnable {

	static val File saveFile = new File("alerts.csv")
	extension val Database database
	val Consumer<Pair<Double, Alert>> triggered
	val List<Alert> alerts = newArrayList()

	new(Database database, Consumer<Pair<Double, Alert>> triggered) {
		this.database = database
		this.triggered = triggered
		load()
	}

	override run() {
		while(true) {
			try {
				if(pairs.stream.flatMap[getAlerts(it).stream].map[it -> Double.parseDouble(it.symbol.lastTrade)].filter [
					val targets = key.targets
					if(value <= targets.key || value >= targets.value) {
						triggered.accept(value -> key)
						key.previousMilestone = value
						return true
					}
					return false
				].count > 0) {
					save()
				}
				Thread.sleep(1000)
			} catch(Exception e) {
				e.printStackTrace()
			}
		}
	}

	def addAlert(String symbol, Long room, double difference) {
		if(getAlert(symbol, difference).present) {
			getAlert(symbol, difference).get().enabledRooms += room
			save()
		} else {
			alerts += new Alert => [ alert |
				alert.symbol = symbol
				alert.difference = difference
				alert.previousMilestone = 0
				alert.enabledRooms = newArrayList(room)
			]
			save()
		}
	}

	def removeAlert(String symbol, Long room) {
		val alertsToRemove = alerts.filter[alert|alert.enabledRooms.contains(room) && alert.symbol.equals(symbol)].toList.stream.collect(Collectors.toList())
		alertsToRemove.forEach[enabledRooms -= room]
		alertsToRemove.stream.filter[enabledRooms.size == 0].forEach[alerts -= it]
		save()
		return alertsToRemove
	}

	def removeAlert(String symbol, double diff, Long room) {
		val alertsToRemove = alerts.filter[alert|alert.enabledRooms.contains(room) && alert.symbol.equals(symbol) && alert.difference == diff].toList.stream.collect(Collectors.toList())
		alertsToRemove.forEach[enabledRooms -= room]
		alertsToRemove.stream.filter[enabledRooms.size == 0].forEach[alerts -= it]
		save()
		return alertsToRemove
	}

	def getAlert(String symbolToSearch, double diff) {
		alerts.stream.filter[symbol.equals(symbolToSearch) && difference == diff].findAny()
	}

	def getAlerts(String symbolToSearch) {
		alerts.stream.filter[symbol.equals(symbolToSearch)].collect(Collectors.toList())
	}

	def getAlerts(long room) {
		alerts.stream.filter[enabledRooms.contains(room)].collect(Collectors.toList())
	}

	def save() {
		save(saveFile)
	}

	def save(File file) {
		val content = alerts.map['''«symbol»,«difference»,«previousMilestone»,«enabledRooms.map[it+""].reduce[a,b|a+"&"+b]»'''].reduce[a, b|a + "\n" + b]
		new PrintWriter(new FileOutputStream(file)) => [
			print(content)
			close()
		]
	}

	def load() {
		load(saveFile)
	}

	def load(File file) {
		alerts.clear()
		alerts += Files.lines(file.toPath).map [
			val cols = split(",")
			val symbol = cols.get(0)
			val diff = Double.parseDouble(cols.get(1))
			val previousMilestone = Double.parseDouble(cols.get(2))
			val enabledRooms = Arrays.stream(cols.get(3).split("&")).map[Long.parseLong(it)].collect(Collectors.toList())
			return new Alert => [ alert |
				alert.symbol = symbol
				alert.difference = diff
				alert.previousMilestone = previousMilestone
				alert.enabledRooms = enabledRooms
			]
		].collect(Collectors.toList())
	}

	def getTargets(Alert alert) {
		val diff = alert.previousMilestone / 100d * alert.difference
		val upper = alert.previousMilestone + diff
		val lower = alert.previousMilestone - diff
		return lower -> upper
	}

	def getPercentualDifference(double previous, double now) {
		return Math.abs((now - previous) / previous * 100)
	}

	@Accessors
	@ToString
	static class Alert {

		var String symbol
		var double difference
		var double previousMilestone
		var List<Long> enabledRooms

	}

}
