-- 15 – Packages
-- https://www.lua.org/pil/15.html

local _i = {r=0, i=1}

local function checkComplex(c)
    if not ((type(c) == "table") and tonumber(c.r) and tonumber(c.i)) then
        error("bad complex number", 3)
    end
end -- checkComplex

local function new(r, i) return {r=r, i=i} end

local function add(c1, c2)
    checkComplex(c1)
    checkComplex(c2)
    return new(c1.r + c2.r, c1.i + c2.i)
end -- add

local function sub(c1, c2)
    return new(c1.r - c2.r, c1.i - c2.i)
end -- sub

local function mul(c1, c2)
    return new(c1.r * c2.r - c1.i * c2.i,
                       c1.r * c2.i + c1.i * c2.r)
end -- mul

local function inv(c)
    local n = c.r^2 + c.i^2
    return new(c.r/n, -c.i/n)
end -- inv

local P = {
    i = _i,
    new = new,
    add = add,
    sub = sub,
    mul = mul,
    inv = inv,
}

if _REQUIREDNAME == nil then
  complex = P
else
  _G[_REQUIREDNAME] = P
end

return P
