-- connect to mqtt and control LED strip on GPIO2 (pin D4)
-- exposes endpoints to control Tower and Shelves LEDS
m = mqtt.Client("nodemcu", 120, "username", "password")
-- connect to mqtt broker and listen to "on/off" messages
-- sent to topic "hue/node1"

s = require("settings")

-- init onboard blue LED, set to off
led = 0
gpio.write(led, gpio.HIGH)
gpio.mode(led, gpio.OUTPUT)



-- wifi connection loop, repeats on timer until connected
function wifi_connect()
   ip = wifi.sta.getip()
     if ip ~= nill then
          print('Connected, ip is:' .. ip)
          tmr.stop(1)
          --pwm.setduty(GPIO2, 0)
          ready = 1
     else
          ready = 0
     end
end

-- mqtt connection loop, repeats on timer until connected
function mqtt_do()
    if ready == 1 then
        mqtt_on()
        --tmr.stop(0)
        m:connect("test.mosquitto.org", 1883, 0, function(conn)
            print("connected")
            connected = 1;
            mqtt_pubsub()
        end)
    end
end

-- subscribe to topics and send a hello message
function mqtt_pubsub()
    m:subscribe("hue/#", 0, function(conn)
        print("subscribed")
    end)

    m:publish("hue/nodemcu", "hello from nodemcu", 0, 0, function(conn)
        print("sent")
    end)
end

function mqtt_on() -- react to messages
    m:lwt("hue/nodemcu", "leaving", 0, 0)
    m:on("connect", function(con)
        print("connected")
        end)

    m:on("offline", function(con)
        print("disconnected... retrying")
        connected = 0;
        end)

    m:on("message", function(conn, topic, data)
        print(topic .. ":" )
        if data ~= nil then
            print(data)
        end
        if topic == "hue/node1" then
            if data == "on" then
                gpio.write(led, gpio.LOW)
            end
            if data == "off" then
                gpio.write(led, gpio.HIGH)
            end
        end
        if topic == "hue/color" then
        	red, green, blue = data:match("#(..)(..)(..)")
			if blue ~= nil then
			  -- center tower strip : 28 leds.
			  red = tonumber(red, 16)
			  green = tonumber(green, 16)
			  blue = tonumber(blue, 16)
			  ws2812.writergb(4, string.char(red, green, blue):rep(28))
			else
			  print("nothing")
			end
        end
    end)
end

connected = 0;
tmr.alarm(0, 1000, 1, function()
     if connected == 0 then -- retry on disconnect
         mqtt_do()
         tmr.delay(1000)
     end
     end)

tmr.alarm(1, 1111, 1, function()
     wifi_connect()
     end)
