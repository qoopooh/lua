/**
 * https://blog.devgenius.io/how-to-add-your-c-library-in-lua-46fd246f0fa8
 *
 * gcc -I/usr/include/lua5.1 nativefunc.c -c -fPIC
 * gcc nativefunc.o -shared -o libnativefunc.so
 *
 * ./usenative.lua
 */

#include <lua.h>
#include <lauxlib.h>

static int l_mult50(lua_State* L)
{
  /* get argument */
  //double number = lua_tonumber(L, 1);
  double number = luaL_checknumber(L, 1); // check type of its argument

  /* push result */
  lua_pushnumber(L, number*50);
  return 1; // number of results
}

int luaopen_libnativefunc(lua_State* L)
{
  static const struct luaL_Reg nativeFuncLib [] = {
    {"mult50", l_mult50},
    {NULL, NULL} /* sentinel */
  };
  luaL_register(L, "nativelib", nativeFuncLib);
  return 1;
}
