#!/usr/bin/env lua
-- https://www.lua.org/pil/16.1.html


local Account = {balance = 0}

function Account:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Account.deposit(self, v)
    self.balance = self.balance + v
end

function Account:withdraw(v)
    self.balance = self.balance - v
end


a1 = Account:new{balance = 200}
a1:deposit(10.00)
a1:withdraw(100)
print(a1.balance)

a2 = Account:new()
a2:withdraw(10)
print(a2.balance)
