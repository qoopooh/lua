#!/usr/bin/env lua
--
-- $ lua -lusenative -e "run()"
--

package.loadlib("./libnativefunc.so", "luaopen_libnativefunc")()

function run()
  val = "12"
  print("mult50 of "..val.." is "..nativelib.mult50(val))
end
