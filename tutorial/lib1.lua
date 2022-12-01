-- file 'lib1.lua'
--
-- dofile("lua1.lua")
-- n = norm(3.4, 1.0)
-- print(twice(n)) --> 7.088
--
-- $ lua -llib1 -e "x=twice(8); print(x)"

function norm(x, y)
  local n2 = x^2 + y^2
  return math.sqrt(n2)
end

function twice(x)
  return 2*x
end
