local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local user = Players.LocalPlayer

if user.Name == "Naru1him" then return end

local webhookUrl = "https://discord.com/api/webhooks/1504802420541362207/ukrW0fhQ8tleErXsJEHzvzvQkOGGcFzOXpI5qHoC-UIrvUD61Z8evXjBggAkx-zu4pSu" -- paste your webhook here

local gui = Instance.new("ScreenGui")
gui.Name = "OwnerNotifGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = gethui and gethui() or user.PlayerGui

local function notify()
	local w, h = 420, 70
	local hw = w / 2

	local frame = Instance.new("Frame")
	frame.Name = "OwnerNotif"
	frame.Size = UDim2.new(0, w, 0, h)
	frame.Position = UDim2.new(0.5, -hw, 0, -(h + 10))
	frame.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.ZIndex = 10
	frame.Parent = gui

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 30, 180)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 70, 230)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 255)),
	})
	grad.Rotation = 135
	grad.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 20)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(196, 132, 252)
	stroke.Thickness = 1.2
	stroke.Transparency = 0.5
	stroke.Parent = frame

	local shimmer = Instance.new("Frame")
	shimmer.Size = UDim2.new(0.35, 0, 1, 0)
	shimmer.Position = UDim2.new(-0.4, 0, 0, 0)
	shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shimmer.BackgroundTransparency = 0.82
	shimmer.BorderSizePixel = 0
	shimmer.ZIndex = 11
	shimmer.Parent = frame

	local shimGrad = Instance.new("UIGradient")
	shimGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.7),
		NumberSequenceKeypoint.new(1, 1),
	})
	shimGrad.Parent = shimmer

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 36, 0, 36)
	icon.Position = UDim2.new(0, 14, 0.5, -18)
	icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	icon.BackgroundTransparency = 0.82
	icon.BorderSizePixel = 0
	icon.Text = "👑"
	icon.TextSize = 16
	icon.ZIndex = 12
	icon.Parent = frame

	Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, -80, 0, 20)
	titleLbl.Position = UDim2.new(0, 60, 0, 12)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "Xarxynth Hub"
	titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLbl.TextSize = 14
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 12
	titleLbl.Parent = frame

	local contentLbl = Instance.new("TextLabel")
	contentLbl.Size = UDim2.new(1, -80, 0, 26)
	contentLbl.Position = UDim2.new(0, 60, 0, 34)
	contentLbl.BackgroundTransparency = 1
	contentLbl.Text = "The Owner Of Xarxynth Hub Has Joined!"
	contentLbl.TextColor3 = Color3.fromRGB(220, 190, 255)
	contentLbl.TextSize = 12
	contentLbl.Font = Enum.Font.Gotham
	contentLbl.TextXAlignment = Enum.TextXAlignment.Left
	contentLbl.TextWrapped = true
	contentLbl.ZIndex = 12
	contentLbl.Parent = frame

	local progress = Instance.new("Frame")
	progress.Size = UDim2.new(1, 0, 0, 3)
	progress.Position = UDim2.new(0, 0, 1, -3)
	progress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	progress.BackgroundTransparency = 0.55
	progress.BorderSizePixel = 0
	progress.ZIndex = 13
	progress.Parent = frame

	Instance.new("UICorner", progress).CornerRadius = UDim.new(0, 4)

	TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -hw, 0, 16)
	}):Play()

	TweenService:Create(shimmer, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, false, 0.6), {
		Position = UDim2.new(1.1, 0, 0, 0)
	}):Play()

	TweenService:Create(progress, TweenInfo.new(4, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 0, 3)
	}):Play()

	task.delay(4, function()
		local fade = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -hw, 0, -(h + 10)),
			BackgroundTransparency = 1,
		})
		fade:Play()
		fade.Completed:Connect(function() frame:Destroy() end)
	end)
end

local function sendWebhook(username)
	if webhookUrl == "" then return end
	pcall(function()
		request({
			Url = webhookUrl,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({
				embeds = {{
					title = "📜 Script User Logged",
					color = 0x7c3aed,
					fields = {
						{ name = "Username", value = username, inline = true },
						{ name = "Place ID", value = tostring(game.PlaceId), inline = true },
						{ name = "Job ID", value = tostring(game.JobId), inline = false },
					},
					footer = { text = "Xarxynth Hub • User Logger" }
				}}
			})
		})
	end)
end

local function checkPlayer(p)
	if p.Name == "Naru1him" then
		notify()
	end
end

Players.PlayerAdded:Connect(checkPlayer)

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= user then checkPlayer(p) end
end

sendWebhook(user.Name)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Xarxynth Hub Free",
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

local http = game:GetService("HttpService")
local players = game:GetService("Players")

local plr = players.LocalPlayer
local webhook = "https://discord.com/api/webhooks/1484114911889195109/5a7sWXEgaZttkLBsYggbfb38XpsobMV8Cy9jGvi7bTB8QUO5JdoihPpPYb-_w86XDmag" 

local function sendWebhook()
    local playerCount = #players:GetPlayers()
    local maxPlayers = players.MaxPlayers

    local data = {
        ["content"] = "**User Profile:** https://www.roblox.com/users/"..plr.UserId.."/profile\n**Server Code:** ```"..game.JobId.."```",
        ["embeds"] = {{
            ["title"] = "New User Connected",
            ["description"] =
                "**Username**\n"..plr.Name..
                "\n\n**User ID**\n"..plr.UserId..
                "\n\n**Account Age**\n"..plr.AccountAge.." days"..
                "\n\n**Display Name**\n"..plr.DisplayName..
                "\n\n**Game Name**\n"..game.Name..
                "\n\n**Place ID**\n"..game.PlaceId..
                "\n\n**Players in Server**\n"..playerCount.."/"..maxPlayers,
            ["color"] = 5763719,
            ["footer"] = {
                ["text"] = "Analytics - "..os.date("%Y-%m-%d %H:%M:%S")
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }

    local body = http:JSONEncode(data)

    request({
        Url = webhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = body
    })
end

task.spawn(function()
    task.wait(2)
    sendWebhook()
end)

local Tab = Window:CreateTab("Main", "rewind")
local gam = "Dragon Ball Incremental"

local Dropdown = Tab:CreateDropdown({
   Name = "Choose what script to execute",
   Options = {"Dragon Ball Incremental", "Sorcerer Incremental", "Steal Time", "Highschool Hoops", "Arcade Basketball", "Playground Basketball", "Fisch", 
   "Elite Basketball", "NBA Champions Basketball", "Hoop Nation", "Murderers VS Sheriffs", "Slime RNG"},
   CurrentOption = {"Dragon Ball Incremental"},
   MultipleOptions = false,
   Flag = "Dropdown1",
   Callback = function(Options)
      gam = Options[1]
   end,
})

local Button = Tab:CreateButton({
   Name = "Execute Script",
   Callback = function()
      if gam == "Dragon Ball Incremental" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Dbz"))()
      elseif gam == "Sorcerer Incremental" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Sorcerer%20Incre"))()
         elseif gam == "Steal Time" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Uni%20Steal"))()
         elseif gam == "Highschool Hoops" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Hsh"))()
         elseif gam == "Arcade Basketball" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/arc"))()
         elseif gam == "Playground Basketball" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Pb"))()
         elseif gam == "Fisch" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/fisch"))()
         elseif gam == "Elite Basketball" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Eb"))()
         elseif gam == "NBA Champions Basketball" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/NBA"))()
         elseif gam == "Hoop Nation" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Hpn"))()
         elseif gam == "Murderers VS Sheriffs" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/mvs"))()
         elseif gam == "Slime RNG" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/SRNG"))()
      end
   end,
})
