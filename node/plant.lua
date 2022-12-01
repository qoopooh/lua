vdd = adc.read(0)
print("Analog = "..vdd.." mV\n")

LED_G = 6
LED_B = 7
LED_R = 8

gpio.mode(LED_G, gpio.OUTPUT)
gpio.write(LED_G, gpio.LOW)

gpio.mode(LED_B, gpio.OUTPUT)
gpio.write(LED_B, gpio.LOW)

gpio.mode(LED_R, gpio.OUTPUT)
gpio.write(LED_R, gpio.LOW)

function show_led_status(val)
  print('\nAnalog: '..val)
  for pin=6,8,1 do
    print('pin '..pin..': '..gpio.read(pin))
  end
end

function set_led(out)
  for pin=6,8,1 do
    if pin == out then
      gpio.write(pin, gpio.HIGH)
    else
      gpio.write(pin, gpio.LOW)
    end
  end
end

previous_val = 0
tmr.alarm(1, 2000, tmr.ALARM_AUTO, function()

  if gpio.read(LED_R) == 0 then
    gpio.write(LED_R, gpio.HIGH)
    gpio.write(LED_R, gpio.LOW)
  end

  val = adc.read(0)

  diff = previous_val - val
  if diff < 11 and diff > -11 then
    return
  end

  previous_val = val

  if val > 240 then
    set_led(0)
  elseif val > 160 then
    set_led(LED_R)
  elseif val > 80 then
    set_led(LED_G)
  else
    set_led(LED_B)
  end

  show_led_status(val)

end)
