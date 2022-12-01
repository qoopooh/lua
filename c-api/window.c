/**
 * Build: gcc -I/usr/include/lua5.1 window.c -llua5.1
 */
#include <stdio.h>
#include <string.h>

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>


#define MAX_COLOR 255

struct ColorTable {
  char *name;
  unsigned char red, green, blue;
} colortable [] = {
  {"WHITE", MAX_COLOR, MAX_COLOR, MAX_COLOR},
  {"RED", MAX_COLOR, 0, 0},
  {"GREEN", 0, MAX_COLOR, 0},
  {"BLUE", 0, 0, MAX_COLOR},
  {"BLACK", 0, 0, 0},
  {"GRAY", 50, 50, 50},
  {NULL, 0, 0, 0} /* sentinel */
}; // ColorTable


lua_State *L;


void setfield (const char *index, int value) {
  lua_pushstring(L, index);
  lua_pushnumber(L, (double) value/MAX_COLOR);
  lua_settable(L, -3);
}


void setcolor (struct ColorTable *ct) {
  lua_newtable(L);
  setfield("r", ct->red);
  setfield("g", ct->green);
  setfield("b", ct->blue);
  lua_setglobal(L, ct->name);
}


int getfield (const char *key) {
  int result;

  lua_pushstring(L, key);
  lua_gettable(L, -2);  /* get background[key] */
  if (!lua_isnumber(L, -1))
    fprintf(stderr, "invalid component in background color\n");
  if (!lua_istable(L, -2))
    fprintf(stderr, "`background' is not a valid color table\n");

  result = (int) (lua_tonumber(L, -1) * MAX_COLOR);
  lua_pop(L, 1); /* remove number */

  return result;
}

void load (char *filename, int *width, int *height) {

  L = lua_open();
  luaL_openlibs(L);
  //luaopen_base(L);
  //luaopen_io(L);
  //luaopen_string(L);
  //luaopen_math(L);

  if (luaL_loadfile(L, filename) || lua_pcall(L, 0, 0, 0)) {
    //error(L, "cannot run configuration file: %s", lua_tostring(L, -1));
    fprintf(stderr, "cannot run configuration file: %s\n", lua_tostring(L, -1));
  }

  lua_getglobal(L, "width");
  lua_getglobal(L, "height");
  if (!lua_isnumber(L, -2))
    fprintf(stderr, "`width' should be a number\n");
  if (!lua_isnumber(L, -1))
    fprintf(stderr, "`height' should be a number\n");

  *width = (int) lua_tonumber(L, -2);
  *height = (int) lua_tonumber(L, -1);
  lua_pop(L, 1);
  lua_pop(L, 1);

  //
  // background color
  //
  unsigned char red, green, blue;
  int i = 0;
  while (colortable[i].name != NULL)
    setcolor(&colortable[i++]);

  lua_getglobal(L, "background");
  if (lua_isstring(L, -1)) {
    const char *name = lua_tostring(L, -1);
    int i = 0;
    while (colortable[i].name != NULL && strcmp(name, colortable[i].name) != 0)
      i++;

    if (colortable[i].name == NULL) { /* string not found? */
      fprintf(stderr, "invalid color name (%s)\n", name);
    } else {
      red = colortable[i].red;
      green = colortable[i].green;
      blue = colortable[i].blue;
    }
  } else if (lua_istable(L, -1)) {
    red = getfield("r");
    green = getfield("g");
    blue = getfield("b");
  } else {
    fprintf(stderr, "`background' is invalid value\n");
  }

  printf("red %d\n", red);
  printf("green %d\n", green);
  printf("blue %d\n", blue);
}


double f (double x, double y) {
  double z;

  lua_getglobal(L, "f");  // function to be called
  lua_pushnumber(L, x);   // push 1st argument
  lua_pushnumber(L, y);   // push 2nd argument

  /* do the call (2 arguments, 1 result) */
  if (lua_pcall(L, 2, 1, 0) != 0) {
    fprintf(stderr, "error running function `f': %s\n", lua_tostring(L, -1));
  }

  /* retrieve result */
  if (!lua_isnumber(L, -1)) {
    fprintf(stderr, "function `f' must return a number\n");
  }

  z = lua_tonumber(L, -1);
  lua_pop(L, 1);    // pop returned value

  return z;
} // f

int main (void) {
  int width;
  int height;

  load((char *) &"window_config.lua", &width, &height);
  printf("Width: %d, Height: %d\n", width, height);
  printf("function f (%d, %d) -> %f\n", width, height, f(width, height));

  return 0;
}
