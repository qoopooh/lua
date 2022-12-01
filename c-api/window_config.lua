-- Configuration file for program `window'
-- define window size

--BLUE = {r=0, g=0, b=1}
--WHITE = {r=1, g=1, b=1}

if os.getenv("DISPLAY") == ":0.0" then
  width = 320
  height = 240
  background = "BLUE"
else
  width, height = 200, 100
  background = {r=0.30, g=0.10, b=0}
  --background = "BLUE"
  --background = "REDA"
  --background = "GRAY"
end


function f (x, y)
  return (x^2 ^ math.sin(y)) / (1 -x)
  --return tonumber(x + y)
  --return 'a'
end
