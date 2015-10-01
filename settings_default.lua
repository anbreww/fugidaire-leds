return {
	-- mqtt connection data
	mqtt_host = "test.mosquitto.org",
	mqtt_port = 1883,
	mqtt_user = "",
	mqtt_pass = "",
	mqtt_id = "esp8266_fugi",

	-- indexes of last LED of each segment (tower, right shelf, rear, left shelf)
	index_tower = 28,
	index_rshelf = 100,
	index_rear = 200,
	index_lshelf = 250,
	ws_gpio = 4,

	-- gpio ports for fans
	fan_warm = 1,
	fan_cool = 2,
	fan_out = 3,
}