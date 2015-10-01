if wifi.sta.status() ~= 5 then tmr.alarm(6, 2000,0, function(d) dofile('init.lua') end) return end
if wifi.sta.status() == 5 then dofile('mqtt-to-ws2812.lua') return end