local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Arcade Basketball",
   Icon = 0,
   LoadingTitle = "Loading Script Please Wait...",
   LoadingSubtitle = "by Xarxynth Hub",
   ShowText = "Rayfield",
   Theme = "Default",

   ToggleUIKeybind = "N",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- =============================================
-- SERVICES
-- =============================================

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local localPlayer = Players.LocalPlayer

-- =============================================
-- TABS
-- =============================================

local Tab     = Window:CreateTab("Main", "rewind")
local MiscTab = Window:CreateTab("Misc", "zap")

-- =============================================
-- AUTO GREEN
-- Only created if hookmetamethod is supported.
-- If not: show one notification and skip the
-- toggle entirely so everything else still loads.
-- =============================================

local hookSupported = typeof(hookmetamethod) == "function"

if not hookSupported then
    Rayfield:Notify({
        Title = "Auto Green Unavailable",
        Content = "Your executor doesn't support hookmetamethod so Auto Green has been hidden. All other features work normally.",
        Duration = 8,
        Image = 4483362458,
    })
else
    local ToggleEnabled = false

    Tab:CreateToggle({
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
        -- Arcade Basketball uses "Shoot" with args[2] = -1
        if ToggleEnabled and method == "FireServer" and self.Name == "Shoot" then
            args[2] = -1
            return old(self, unpack(args))
        end
        return old(self, ...)
    end)
end

-- =============================================
-- SHARED CHARACTER REFS
-- Wrapped in pcall with timeouts so missing
-- Values/Dribbling folders never crash the script.
-- =============================================

local char    = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local hrp     = char:WaitForChild("HumanoidRootPart")
local dribble = nil

local function fetchDribble()
    pcall(function()
        local vals = localPlayer:WaitForChild("Values", 5)
        if vals then
            dribble = vals:WaitForChild("Dribbling", 5)
        end
    end)
end

fetchDribble()

-- Keep refs fresh after every respawn
localPlayer.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp  = newChar:WaitForChild("HumanoidRootPart")
    fetchDribble()
end)

-- =============================================
-- INFINITE STAMINA
-- =============================================

local staminaEnabled = false

Tab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "StaminaToggle",
    Callback = function(v)
        staminaEnabled = v
    end,
})

RunService.Heartbeat:Connect(function()
    if not staminaEnabled then return end
    local vals = localPlayer:FindFirstChild("Values")
    if vals then
        local stam = vals:FindFirstChild("Stamina")
        if stam and stam:IsA("NumberValue") and stam.Value ~= 100 then
            stam.Value = 100
        end
    end
end)

-- =============================================
-- DRIBBLE GLIDE — TranslateBy (Velocity-Based)
-- Glides using MoveDirection when moving,
-- falls back to HRP velocity when not pressing
-- WASD (e.g. during crossovers/animations).
-- =============================================

local glideV1Enabled = false
local glideV1Speed   = 10

Tab:CreateToggle({
    Name = "Dribble Glide",
    CurrentValue = false,
    Flag = "DribbleGlideV1",
    Callback = function(v)
        glideV1Enabled = v
    end,
})

Tab:CreateSlider({
    Name = "Glide Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = glideV1Speed,
    Flag = "GlideSpeedV1",
    Callback = function(v)
        glideV1Speed = v
    end,
})

RunService.Heartbeat:Connect(function(delta)
    if not glideV1Enabled then return end
    if not dribble or not dribble.Value then return end

    local c = localPlayer.Character
    if not c then return end

    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local hrpPart = c:FindFirstChild("HumanoidRootPart")
    if not hrpPart then return end

    local moveDir = hum.MoveDirection

    if moveDir.Magnitude > 0 then
        -- WASD pressed: glide in move direction
        c:TranslateBy(moveDir * glideV1Speed * delta * 10)
    else
        -- No WASD: use HRP velocity so crossovers/animations still carry momentum
        local vel = hrpPart.Velocity
        local flatVel = Vector3.new(vel.X, 0, vel.Z)
        if flatVel.Magnitude > 0.5 then
            local glideDir = flatVel.Unit
            c:TranslateBy(glideDir * glideV1Speed * delta * 10)
        end
    end
end)

-- =============================================
-- AUTO BLOCK
-- Arcade Basketball fires a blockEvent remote
-- rather than using VirtualInput Space.
-- =============================================

local autoBlockEnabled  = false
local autoBlockMaxStuds = 20
local teamCheckEnabled  = false

-- Safe fetch of the block remote with timeout
local blockEvent = nil
pcall(function()
    blockEvent = game:GetService("ReplicatedStorage")
        :WaitForChild("Events", 10)
        :WaitForChild("Block", 10)
end)

Tab:CreateToggle({
    Name = "Auto Block",
    CurrentValue = false,
    Flag = "AutoBlock",
    Callback = function(v)
        autoBlockEnabled = v
    end,
})

Tab:CreateSlider({
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

Tab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(v)
        teamCheckEnabled = v
    end,
})

RunService.Heartbeat:Connect(function()
    if not autoBlockEnabled then return end
    if not blockEvent then return end

    local myHRP           = hrp
    local closestPlayer   = nil
    local closestDistance = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if teamCheckEnabled and plr.Team == localPlayer.Team then
                continue
            end
            -- Arcade Basketball uses a "Shooting" BoolValue
            local shooting = plr:FindFirstChild("Values") and plr.Values:FindFirstChild("Shooting")
            if shooting and shooting:IsA("BoolValue") and shooting.Value == true then
                local dist = (myHRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDistance and dist <= autoBlockMaxStuds then
                    closestDistance = dist
                    closestPlayer   = plr
                end
            end
        end
    end

    if closestPlayer then
        blockEvent:FireServer()
    end
end)

-- =============================================
-- ANTI STEAL
-- Arcade Basketball uses Z key to dribble.
-- =============================================

Tab:CreateParagraph({
    Title = "Anti Steal INFO",
    Content = "Auto-dribbles (Z key) when a nearby opponent has their Stealing value active."
})

local antiStealEnabled  = false
local antiStealMaxStuds = 15
local antiStealCooldown = 0.5
local lastTrigger       = 0

Tab:CreateToggle({
    Name = "Anti Steal",
    CurrentValue = false,
    Flag = "AntiSteal",
    Callback = function(v)
        antiStealEnabled = v
    end,
})

Tab:CreateSlider({
    Name = "Steal Max Distance",
    Range = {1, 30},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = antiStealMaxStuds,
    Flag = "StealDistance",
    Callback = function(v)
        antiStealMaxStuds = v
    end,
})

RunService.Heartbeat:Connect(function()
    if not antiStealEnabled then return end
    if tick() - lastTrigger < antiStealCooldown then return end

    local myHRP           = hrp
    local closestPlayer   = nil
    local closestDistance = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local steal = plr:FindFirstChild("Values") and plr.Values:FindFirstChild("Stealing")
            if steal and steal.Value then
                local dist = (myHRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDistance and dist <= antiStealMaxStuds then
                    closestDistance = dist
                    closestPlayer   = plr
                end
            end
        end
    end

    if closestPlayer then
        lastTrigger = tick()
        for i = 1, 2 do
            VirtualInput:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
            task.wait(0.05)
            VirtualInput:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
        end
    end
end)


-- =============================================
-- AUTO GUARD (REWRITTEN)
-- Finds basketball via workspace.Courts or
-- workspace.Basketballs (practice).
-- Checks Basketball.Player.Value == plr.Name
-- Always positions in FRONT of target (contest).
-- =============================================

Tab:CreateParagraph({
    Title = "Auto Guard INFO",
    Content = "Follows the player holding the Basketball via Player value. Stays in front to contest. Team check supported."
})

local autoGuardEnabled   = false
local autoGuardMaxStuds  = 20
local autoGuardFrontOffset = 3
local autoGuardMode      = "Legit"
local autoGuardTeamCheck = false

Tab:CreateToggle({
    Name = "Auto Guard",
    CurrentValue = false,
    Flag = "AutoGuard",
    Callback = function(v)
        autoGuardEnabled = v
    end,
})

Tab:CreateToggle({
    Name = "Auto Guard Team Check",
    CurrentValue = false,
    Flag = "AutoGuardTeamCheck",
    Callback = function(v)
        autoGuardTeamCheck = v
    end,
})

Tab:CreateSlider({
    Name = "Guard Max Distance",
    Range = {1, 40},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = autoGuardMaxStuds,
    Flag = "GuardMaxStuds",
    Callback = function(v)
        autoGuardMaxStuds = v
    end,
})

Tab:CreateDropdown({
    Name = "Guard Movement Mode",
    Options = {"Legit", "CFrame", "Tween"},
    CurrentOption = {"Legit"},
    MultipleOptions = false,
    Flag = "GuardMoveMode",
    Callback = function(options)
        autoGuardMode = options[1]
    end,
})


Tab:CreateSlider({
    Name = "Guard Front Offset",
    Range = {1, 15},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 3,
    Flag = "GuardFrontOffset",
    Callback = function(v)
        autoGuardFrontOffset = v
    end,
})

local TweenService = game:GetService("TweenService")
local Workspace    = game:GetService("Workspace")

-- Court folder names
local COURT_NAMES = {
    "1v1 (Matchmaking)",
    "1v1 Court_1", "1v1 Court_2", "1v1 Court_3", "1v1 Court_4",
    "2v2 Court_1", "2v2 Court_2",
    "3v3",
    "Wager1v1_1",
}

-- Returns the player who currently holds the basketball
-- by checking Basketball.Player.Value across all courts + practice
local function getPlayerWithBall()
    local myChar = localPlayer.Character
    if not myChar then return nil, math.huge end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil, math.huge end

    local basketballs = {}

    -- Courts
    local courts = Workspace:FindFirstChild("Courts")
    if courts then
        for _, courtName in ipairs(COURT_NAMES) do
            local court = courts:FindFirstChild(courtName)
            if court then
                local ball = court:FindFirstChild("Basketball")
                if ball then
                    table.insert(basketballs, ball)
                end
            end
        end
    end

    -- Practice balls (multiple, dynamic, all named "Basketball")
    local practiceBalls = Workspace:FindFirstChild("Basketballs")
    if practiceBalls then
        for _, ball in ipairs(practiceBalls:GetChildren()) do
            if ball.Name == "Basketball" then
                table.insert(basketballs, ball)
            end
        end
    end

    local closestPlayer = nil
    local closestDist   = math.huge

    for _, ball in ipairs(basketballs) do
        local playerVal = ball:FindFirstChild("Player")
        if not playerVal then continue end

        -- Player is an ObjectValue so .Value is the Player instance directly
        local holder = playerVal.Value
        if not holder then continue end
        if typeof(holder) ~= "Instance" then continue end
        if not holder:IsA("Player") then continue end
        if holder == localPlayer then continue end

        -- Team check
        if autoGuardTeamCheck and holder.Team == localPlayer.Team then continue end

        local holderChar = holder.Character
        if not holderChar then continue end
        local holderHRP = holderChar:FindFirstChild("HumanoidRootPart")
        if not holderHRP then continue end

        local dist = (myHRP.Position - holderHRP.Position).Magnitude
        if dist < closestDist then
            closestDist   = dist
            closestPlayer = holder
        end
    end

    return closestPlayer, closestDist
end

RunService.Heartbeat:Connect(function()
    if not autoGuardEnabled then return end

    local c = localPlayer.Character
    if not c then return end

    local myHRP = c:FindFirstChild("HumanoidRootPart")
    local hum   = c:FindFirstChildOfClass("Humanoid")
    if not myHRP or not hum or hum.Health <= 0 then return end

    local target, dist = getPlayerWithBall()

    if not target or not target.Character then
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        return
    end

    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        return
    end

    if dist > autoGuardMaxStuds then
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        return
    end

    -- Hold F to guard/contest
    VirtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, game)

    -- Always position IN FRONT of target (between target and hoop/their facing direction)
    -- "In front" = opposite of where they're looking, so we face them head-on
    local targetLook  = targetHRP.CFrame.LookVector
local contestPos  = targetHRP.Position + (targetLook * autoGuardFrontOffset) -- 3 studs in front of them
    contestPos        = Vector3.new(contestPos.X, targetHRP.Position.Y, contestPos.Z)

    if autoGuardMode == "Move:To" then
        hum:MoveTo(contestPos)

    elseif autoGuardMode == "CFrame" then
        myHRP.CFrame = CFrame.new(contestPos, targetHRP.Position)

    elseif autoGuardMode == "Tween" then
        local goal = { CFrame = CFrame.new(contestPos, targetHRP.Position) }
        local info = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
        TweenService:Create(myHRP, info, goal):Play()
    end
end)

-- =============================================
-- UNLOCK ALL (SEASON PASS)
-- =============================================

Tab:CreateButton({
    Name = "Unlock All (SEASON PASS)",
    Callback = function()
        localPlayer.Profile.SeasonPass.SeasonPassLevel.Value = 100
    end,
})

-- =============================================
-- MISC TAB — SPEED BOOST
-- TranslateBy + Heartbeat, same as IY tpwalk.
-- Frame-rate independent via delta.
-- Never touches WalkSpeed.
-- =============================================

MiscTab:CreateParagraph({
    Title = "Speed Boost INFO",
    Content = "Pushes you in your move direction every frame via TranslateBy. Works even in games that reset WalkSpeed since it never touches WalkSpeed at all."
})

local speedBoostEnabled = false
local speedBoostAmount  = 30

MiscTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(v)
        speedBoostEnabled = v
    end,
})

MiscTab:CreateSlider({
    Name = "Boost Strength",
    Range = {1, 150},
    Increment = 1,
    Suffix = "",
    CurrentValue = speedBoostAmount,
    Flag = "SpeedBoostAmount",
    Callback = function(v)
        speedBoostAmount = v
    end,
})

RunService.Heartbeat:Connect(function(delta)
    if not speedBoostEnabled then return end

    local c = localPlayer.Character
    if not c then return end

    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local moveDir = hum.MoveDirection
    if moveDir.Magnitude == 0 then return end

    c:TranslateBy(moveDir * speedBoostAmount * delta * 10)
end)

Rayfield:LoadConfiguration()
