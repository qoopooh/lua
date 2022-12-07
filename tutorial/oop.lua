#!/usr/bin/env lua
-- https://www.lua.org/pil/16.1.html
-- https://www.lua.org/pil/16.2.html


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
    if v > self.balance then error"insufficient funds" end
    self.balance = self.balance - v
end

local SpecialAccount = Account:new()

function SpecialAccount:getLimit()
    return self.limit or 0
end

function SpecialAccount:withdraw(v)
    if v - self.balance > self:getLimit() then error"insufficient funds" end
    self.balance = self.balance - v
end

local a1 = Account:new{balance = 200}
a1:deposit(10.00)
a1:withdraw(100)
print(a1.balance)

local a2 = Account:new()
a2:deposit(10)
a2:withdraw(10.00)
print(a2.balance)

local a3 = SpecialAccount:new{limit=100}
a3:withdraw(100.00)
print(a3.balance)

return {
    Account = Account,
    SpecialAccount = SpecialAccount
}
