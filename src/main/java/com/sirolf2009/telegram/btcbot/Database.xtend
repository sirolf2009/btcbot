package com.sirolf2009.telegram.btcbot

import java.util.List
import org.influxdb.InfluxDB
import org.influxdb.InfluxDBFactory
import org.influxdb.dto.Query

class Database {
	
	val InfluxDB db
	
	new(String host) {
		db = InfluxDBFactory.connect(host)
	}

	def String getLastTrade(String symbol) {
		return db.query(new Query('''SELECT price FROM trade where pair='«symbol»' ORDER BY time desc limit 1''', "trades")).results.head.series.head.values.head.get(1) + ""
	}

	def List<String> getPairs() {
		return db.query(new Query('''SELECT DISTINCT(pair) FROM trade''', "trades")).results.head.series.head.values.map[get(1) + ""]
	}
	
}