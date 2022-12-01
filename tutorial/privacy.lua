#!/usr/bin/env lua
-- https://www.lua.org/pil/16.4.html


local function newAccount(initialBalance)
    local self = {
        balance = initialBalance or 0,
        LIM = 1000,
    }

    local extra = function ()
        if self.balance > self.LIM then
            return self.balance * 0.10
        end

        return 0
    end -- extra (private method)

    local getBalance = function()
        return self.balance + extra()
    end -- getBalance

    local deposit = function(v)
        self.balance = self.balance + v
    end -- deposit

    local withdraw = function(v)
        self.balance = self.balance - v
    end -- withdraw

    return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance,
    }
end -- newAccount

local a1 = newAccount(200)
a1.deposit(10.00)
a1.withdraw(100)
print(a1.getBalance())

local a2 = newAccount()
a2.deposit(10)
a2.withdraw(10.00)
print(a2.getBalance())

return {
    newAccount = newAccount,
}
