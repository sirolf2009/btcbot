package com.sirolf2009.telegram.btcbot.command

import com.sirolf2009.telegram.btcbot.Database
import java.util.Map
import java.util.List
import org.eclipse.xtend.lib.annotations.Data
import java.text.DecimalFormat

class CommandArbritrage extends Command {

	new(extension Database database) {
		// XRP/BTC, LTC/EUR, LTC/USD, USD/XRP, LTC/BTC, BTC/USD, EUR/USD, BTC/EUR, EUR/XRP
		super("arbritrage", "", "List current available arbritrage") [
			val prices = pairs.map[it -> Double.parseDouble(lastTrade)].toMap([key], [value])
			val arbritrages = #[
				CommandArbritrage.getArbritrage(prices, #["BTC", "USD", "LTC", "BTC"]), //
				CommandArbritrage.getArbritrage(prices, #["BTC", "LTC", "USD", "BTC"]), //
//				CommandArbritrage.getArbritrage(prices, #["BTC", "USD", "XRP", "BTC"]), //
//				CommandArbritrage.getArbritrage(prices, #["BTC", "XRP", "USD", "BTC"]), //
				CommandArbritrage.getArbritrage(prices, #["BTC", "EUR", "LTC", "BTC"]), //
				CommandArbritrage.getArbritrage(prices, #["BTC", "LTC", "EUR", "BTC"]) //
//				CommandArbritrage.getArbritrage(prices, #["BTC", "EUR", "XRP", "BTC"]), //
//				CommandArbritrage.getArbritrage(prices, #["BTC", "XRP", "EUR", "BTC"])
			].filter[profit > 0].map[toString()].reduce[a, b|a + "\n" + b]
			return arbritrages
		]
	}

	def static getArbritrage(Map<String, Double> prices, List<String> order) {
		var balance = 1d
		val steps = newArrayList()
		val pairs = (1 ..< order.size()).map [
			val from = order.get(it - 1)
			val to = order.get(it)
			return from -> to
		].toList()
		for (Pair<String, String> pair : pairs) {
			val conversionRate = prices.getConversionRate(pair)
			val newBalance = balance * conversionRate
			steps.add(new ArbritrageStep(pair.key, pair.value, conversionRate, balance, newBalance))
			balance = newBalance
		}
		val profit = balance - 1
		return new Arbritrage(prices, order, steps, profit)
	}

	def static getConversionRate(Map<String, Double> prices, Pair<String, String> pair) {
		prices.getConversionRate(pair.key, pair.value)
	}

	def static getConversionRate(Map<String, Double> prices, String from, String to) {
		val fromTo = '''«from»/«to»'''
		val toFrom = '''«to»/«from»'''
		if(prices.containsKey(fromTo)) {
			return prices.get(fromTo)
		} else if(prices.containsKey(toFrom)) {
			return 1 / prices.get(toFrom)
		} else {
			throw new IllegalArgumentException('''Invalid pair «from»/«to»''')
		}
	}

	@Data
	public static class Arbritrage {

		static val format = new DecimalFormat("#,###,###,##0.00#####")

		val Map<String, Double> prices
		val List<String> order
		val List<ArbritrageStep> steps
		val double profit

		override toString() {
			steps.map['''«from»->«to»	rate: «conversionRate.format»	«initialBalance.format» «from» -> «newBalance.format» «to»'''].reduce[a, b|a + "\n" + b] + "\nProfit: " + profit
		}

		def format(double number) {
			return format.format(number)
		}

	}

	@Data
	public static class ArbritrageStep {

		val String from
		val String to
		val double conversionRate
		val double initialBalance
		val double newBalance

	}

}
