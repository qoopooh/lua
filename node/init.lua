--load credentials
--SID and PassWord should be saved according wireless router in use
dofile("credentials.lua")

function startup()
    if file.open("init.lua") == nil then
      print("init.lua deleted")
    else
      print("Running")
      file.close("init.lua")
      dofile("plant.lua")
    end
end

--init.lua
wifi.sta.disconnect()
print("set up wifi mode")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWORD,0)
wifi.sta.connect()
tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip()== nil then 
        print("IP unavaiable, Waiting...") 
    else 
        tmr.stop(1)
        print("Config done, IP is "..wifi.sta.getip())
        print("You have 2 seconds to abort Startup")
        print("Waiting...")
        tmr.alarm(0,2000,tmr.ALARM_SINGLE,startup)
    end 
 end)
