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

-- Secured HTTP Downloader
local function secureFetch(url)
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

    local success, response = pcall(request, {
        Url = url,
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

-- RAW SCRIPT URL
local scriptUrl = "https://raw.githubusercontent.com/SoftRatatui/rivmain/refs/heads/main/rivmain.luau"

local runScript = secureFetch(scriptUrl)
if runScript then
    task.spawn(runScript)
end
