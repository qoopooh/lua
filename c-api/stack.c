/**
 * Test with lua 5.1
 * 
 * Install: sudo apt install liblua5.1-0-dev
 *
 * Build: gcc -I/usr/include/lua5.1 stack.c -llua5.1 -lm
 */
#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>

static void stackDump (lua_State *L) {
  int i;
  int top = lua_gettop(L);

  for (i = 1; i <= top; i++) {
    int t = lua_type(L, i);
    switch (t) {

      case LUA_TSTRING:
        printf("`%s'", lua_tostring(L, i));
        break;

      case LUA_TBOOLEAN:
        printf(lua_toboolean(L, i) ? "true" : "false");
        break;

      case LUA_TNUMBER:
        printf("%g", lua_tonumber(L, i));
        break;

      default:
        printf("%s", lua_typename(L, t));
        break;

    }

    printf("  ");
  }
  printf("\n");

} // stackDump


int main (void) {

  printf("Hello\n");
  lua_State *L = luaL_newstate();
  lua_pushboolean(L, 1);
  lua_pushnumber(L, 10);
  lua_pushnil(L);
  lua_pushstring(L, "hello");
  stackDump(L);

  lua_pushvalue(L, -4); stackDump(L);

  lua_replace(L, 3); stackDump(L);
  lua_settop(L, 6); stackDump(L);  /* true  10  true  `hello'  nil  nil  */
  lua_remove(L, -3); stackDump(L); /* true  10  true  nil  nil  */
  lua_settop(L, -5); stackDump(L); /* true  */

  lua_close(L);
  return 0;
}
