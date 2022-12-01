#!/usr/bin/env lua
-- https://www.lua.org/pil/6.3.html
-- Proper Tail Calls
-- luacheck maze.lua --globals room1 room2 room3 room4


local Maze = {}

function Maze.new(m)
    return m
end -- new

function Maze.invalid()
    print("invalid move (north, south, east, west)")
end -- invalid

function Maze.room1(m)
    local move = io.read()
    if move == 'south' then return m:room3()
    elseif move == 'east' then return m:room2()
    else
        m:invalid()
        return m:room1()    -- stay in the same room
    end
end -- room1

function Maze.room2(m)
    local move = io.read()
    if move == 'south' then return m:room4()
    elseif move == 'west' then return m:room1()
    else
        m:invalid()
        return m:room2()    -- stay in the same room
    end
end -- room2

function Maze.room3(m)
    local move = io.read()
    if move == 'north' then return m:room1()
    elseif move == 'east' then return m:room4()
    else
        m:invalid()
        return m:room3()    -- stay in the same room
    end
end -- room3

function Maze.room4()
    print("congratulations!")
end -- room4

local m = Maze:new()
m:room1()
