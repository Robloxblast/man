local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Arcade Basketball",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading Script Please Wait...",
   LoadingSubtitle = "by Xarxynth Hub",
   ShowText = "Rayfield", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "N", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

local Tab = Window:CreateTab("Main", "rewind")

local ToggleEnabled = false

local Toggle = Tab:CreateToggle({
    Name = "Auto Green",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        ToggleEnabled = Value
    end,
})

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if ToggleEnabled and method == "FireServer" and self.Name == "Shoot" then
        args[2] = -1
        return old(self, unpack(args))
    end

    return old(self, ...)
end)


local staminaToggle = false
local rs = game:GetService("RunService")

Tab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "StaminaToggle",
    Callback = function(v)
        staminaToggle = v
    end,
})

rs.Heartbeat:Connect(function()
    if staminaToggle then
        local p = game:GetService("Players").LocalPlayer
        local vals = p:FindFirstChild("Values")
        if vals then
            local stam = vals:FindFirstChild("Stamina")
            if stam and stam:IsA("NumberValue") and stam.Value ~= 100 then
                stam.Value = 100
            end
        end
    end
end)

local p = game:GetService("Players").LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local hrp = c:WaitForChild("HumanoidRootPart")
local vals = p:WaitForChild("Values")
local dribble = vals:WaitForChild("Dribbling")

local enabled = false
local addAmount = 10

local Toggle = Tab:CreateToggle({
    Name = "Dribble Glide",
    CurrentValue = false,
    Flag = "DribbleGlide",
    Callback = function(v)
        enabled = v
    end,
})

local Slider = Tab:CreateSlider({
    Name = "Glide Amount",
    Range = {1, 20},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = addAmount,
    Flag = "GlideAmount",
    Callback = function(v)
        addAmount = v
    end,
})

game:GetService("RunService").Heartbeat:Connect(function()
    if enabled and dribble.Value then
        local bv = hrp:FindFirstChild("BodyVelocity")
        if bv then
            local v = bv.Velocity

            local x = v.X ~= 0 and (v.X + (v.X > 0 and addAmount or -addAmount)) or 0
            local z = v.Z ~= 0 and (v.Z + (v.Z > 0 and addAmount or -addAmount)) or 0

            bv.Velocity = Vector3.new(x, v.Y, z)
        end
    end
end)

local p = game:GetService("Players").LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local hrp = c:WaitForChild("HumanoidRootPart")
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local blockEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Block")

local autoBlockEnabled = false
local autoBlockMaxStuds = 20

-- Auto Block Toggle
local BlockToggle = Tab:CreateToggle({
    Name = "Auto Block",
    CurrentValue = false,
    Flag = "AutoBlock",
    Callback = function(v)
        autoBlockEnabled = v
    end,
})

-- Auto Block Distance Slider
local BlockSlider = Tab:CreateSlider({
    Name = "Block Max Distance",
    Range = {1, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = autoBlockMaxStuds,
    Flag = "BlockDistance",
    Callback = function(v)
        autoBlockMaxStuds = v
    end,
})

RunService.Heartbeat:Connect(function()
    if not autoBlockEnabled then return end

    local closestPlayer = nil
    local closestDistance = math.huge

    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= p and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local shooting = plr:FindFirstChild("Values") and plr.Values:FindFirstChild("Shooting")
            if shooting and shooting:IsA("BoolValue") and shooting.Value == true then
                local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDistance and dist <= autoBlockMaxStuds then
                    closestDistance = dist
                    closestPlayer = plr
                end
            end
        end
    end

    if closestPlayer then
        blockEvent:FireServer()
    end
end)


local Paragraph = Tab:CreateParagraph({Title = "Anti Steal INFO", Content = "What Anti Steal does is it will auto dribble if someone tries to steal from you"})

local p = game:GetService("Players").LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local hrp = c:WaitForChild("HumanoidRootPart")
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local antiStealEnabled = false
local antiStealMaxStuds = 15

-- Anti Steal Toggle
local StealToggle = Tab:CreateToggle({
    Name = "Anti Steal",
    CurrentValue = false,
    Flag = "AntiSteal",
    Callback = function(v)
        antiStealEnabled = v
    end,
})

-- Anti Steal Distance Slider
local StealSlider = Tab:CreateSlider({
    Name = "Steal Max Distance",
    Range = {1, 30},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = antiStealMaxStuds,
    Flag = "StealDistance",
    Callback = function(v)
        antiStealMaxStuds = v
    end,
})

RunService.Heartbeat:Connect(function()
    if not antiStealEnabled then return end

    local closestPlayer = nil
    local closestDistance = math.huge

    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= p and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local steal = plr:FindFirstChild("Values") and plr.Values:FindFirstChild("Stealing")
            if steal and steal.Value then
                local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDistance and dist <= antiStealMaxStuds then
                    closestDistance = dist
                    closestPlayer = plr
                end
            end
        end
    end

    if closestPlayer then
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        wait(0.05)
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end
end)


local Button = Tab:CreateButton({
   Name = "Unlock All (SEASON PASS)",
   Callback = function()
   game:GetService("Players").LocalPlayer.Profile.SeasonPass.SeasonPassLevel.Value = 100
   end,
})

Rayfield:LoadConfiguration()
