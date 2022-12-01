local function get_id(o)
    local text = tostring(o)
    local start = string.find(text, 'x') + 1
    return string.sub(text, start)
end -- get_id

return get_id
