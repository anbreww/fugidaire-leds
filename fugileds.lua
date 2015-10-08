local fugileds = {}

local s = require("settings")

local leds_tower = string.char(0, 0, 0):rep(s.index_tower)
local leds_rshelf = string.char(0, 0, 0):rep(s.index_rshelf)
local leds_rear = string.char(0, 0, 0):rep(s.index_rear)
local leds_lshelf = string.char(0, 0, 0):rep(s.index_lshelf)

function fugileds.hex_to_str(hex_color)
	local red, green, blue = hex_color:match("#(..)(..)(..)")
	if blue ~= nil then
		-- center tower strip : 28 leds.
		red = tonumber(red, 16)
		green = tonumber(green, 16)
		blue = tonumber(blue, 16)
		color_str = string.char(red, green, blue)
	else
		color_str = string.char(0, 0, 0)
	end 
	return color_str
end

function fugileds.process_data(topic, data)
	color_str = fugileds.hex_to_str(data)
	if topic == 'color' then
		fugileds.set_all(color_str)
	elseif topic == 'tower' then
		fugileds.set_tower(color_str)
	elseif topic == 'rshelf' then
		fugileds.set_rshelf(color_str)
	elseif topic == 'rear' then
		fugileds.set_rear(color_str)
	elseif topic == 'lshelf' then
		fugileds.set_lshelf(color_str)
	end
	fugileds.update()
end

function fugileds.set_tower(color_str)
	leds_tower = color_str:rep(s.index_tower)	
end

function fugileds.set_rshelf(color_str)
	leds_rshelf = color_str:rep(s.index_rshelf)
end

function fugileds.set_rear(color_str)
	leds_rear = color_str:rep(s.index_rear)
end

function fugileds.set_lshelf(color_str)
	leds_lshelf = color_str:rep(s.index_lshelf)
end

function fugileds.set_all(color_str)
	fugileds.set_tower(color_str)
	fugileds.set_rshelf(color_str)
	fugileds.set_rear(color_str)
	fugileds.set_lshelf(color_str)
end

function fugileds.restore_state(message)
	tower, rshelf, rear, lshelf = message:match("([^,]+),([^,]+),([^,]+),([^,]+)")
	fugileds.set_tower(fugileds.hex_to_str(tower))
	fugileds.set_rshelf(fugileds.hex_to_str(rshelf))
	fugileds.set_rear(fugileds.hex_to_str(rear))
	fugileds.set_lshelf(fugileds.hex_to_str(lshelf))
	fugileds.update()
end

function fugileds.update()
	local led_str = leds_tower..leds_rshelf..leds_rear..leds_lshelf
	print(led_str)
	print(string.len(led_str))
	ws2812.writergb(s.ws_gpio, led_str)
end


return fugileds