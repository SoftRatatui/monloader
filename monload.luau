if not game:IsLoaded() then
    game.Loaded:Wait()
end

local v1 = game:GetService("Players")
local v2 = v1.LocalPlayer
if not v2 then
    v1:GetPropertyChangedSignal("LocalPlayer"):Wait()
    v2 = v1.LocalPlayer
end

local function v3(v4, v5)
    local v6 = messageboxasync or messagebox
    if type(v6) == "function" then
        pcall(v6, v5, v4, 16)
    else
        warn(v4 .. ": " .. v5)
    end
end

local function v7(v8)
    local v9 = request or http_request or syn.request
    local v10 = loadstring or eloadstring
    if type(v10) ~= "function" then
        v3("Error", "Missing loadstring")
        return nil
    end
    local v11 = nil
    local v12 = v8 .. "?t=" .. tostring(math.random(1, 100000))
    local v13, v14 = pcall(function()
        return game:HttpGet(v12)
    end)
    if v13 and type(v14) == "string" and #v14 > 1000 and not v14:find("<!DOCTYPE html>") then
        v11 = v14
    end
    if not v11 and type(v9) == "function" then
        local v15, v16 = pcall(v9, {
            Url = v12,
            Method = "GET"
        })
        if v15 and type(v16) == "table" and v16.StatusCode == 200 and type(v16.Body) == "string" then
            if #v16.Body > 1000 and not v16.Body:find("<!DOCTYPE html>") then
                v11 = v16.Body
            end
        end
    end
    if not v11 then
        v3("Error", "Failed to fetch script")
        return nil
    end
    local v17, v18 = v10(v11)
    if not v17 then
        v3("Error", tostring(v18))
        return nil
    end
    return v17
end

local v19 = v7("https://raw.githubusercontent.com/SoftRatatui/rivmain/main/rivmain.luau")
if v19 then
    task.spawn(v19)
end
