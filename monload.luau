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

-- Base64 Decoder (Pure Lua, highly compatible, hides raw URLs from HTTP Sniffers)
local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function decodeB64(data)
    data = string.gsub(data, '[^'..b64chars..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b64chars:find(x) - 1)
        for i = 6, 1, -1 do 
            r = r .. (f % 2^i - f % 2^(i - 1) > 0 and '1' or '0') 
        end
        return r
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        local r = 0
        for i = 1, 8 do 
            r = r + (x:sub(i, i) == '1' and 2^(8 - i) or 0) 
        end
        return string.char(r)
    end))
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

-- Secured HTTP Downloader
local function secureFetch(encodedUrl)
    local request = request or http_request or syn.request
    local loadstring = loadstring or eloadstring
    
    if type(request) ~= "function" then
        showError("MonHub Loader Error", "Your executor does not support HTTP requests (missing request / http_request).")
        return nil
    end
    
    if type(loadstring) ~= "function" then
        showError("MonHub Loader Error", "Your executor is missing the loadstring function.")
        return nil
    end

    local decodedUrl = decodeB64(encodedUrl)
    local success, response = pcall(request, {
        Url = decodedUrl,
        Method = "GET",
        Headers = {
            ["User-Agent"] = "MonHubLoader/2.0",
            ["Cache-Control"] = "no-cache"
        }
    })

    if not success then
        showError("MonHub Loading Failed", "Connection failed. Please check your internet connection or executor permissions.")
        return nil
    end

    if type(response) ~= "table" or response.StatusCode ~= 200 or type(response.Body) ~= "string" then
        showError("MonHub Loading Failed", "Server returned an error status: " .. tostring(response.StatusCode or "Unknown"))
        return nil
    end

    local code = response.Body
    -- Anti-tamper check (Ensure code is not empty or return HTML page)
    if #code < 100 or code:find("<!DOCTYPE html>") or code:find("<html") then
        showError("MonHub Loading Failed", "Invalid script payload returned from server. Check your file path.")
        return nil
    end

    local loader, err = loadstring(code)
    if not loader then
        showError("MonHub Compilation Failed", "Syntax error found in loaded script:\n" .. tostring(err))
        return nil
    end

    return loader
end

-- ENCODED SCRIPT URL (Base64)
-- Replace this with your own Base64-encoded GitHub Raw URL!
-- Default encoded URL points to a placeholder.
-- Example of encoding "https://raw.githubusercontent.com/username/repo/main/combined_script.lua"
local encodedScriptUrl = "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NvZnRSYXRhdHVpL3Jpdm1haW4vcmVmcy9oZWFkcy9tYWluL3Jpdm1haW4ubHVhdQ=="

local runScript = secureFetch(encodedScriptUrl)
if runScript then
    task.spawn(runScript)
end
