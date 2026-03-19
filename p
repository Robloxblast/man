local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Xarxynth Hub Paid",
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
   Options = {"Dragon Ball Incremental", "Sorcerer Incremental", "Steal Time", "Highschool Hoops", "Arcade Basketball", "Playground Basketball", "Fisch"},
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
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Hsh%20paid"))()
         elseif gam == "Arcade Basketball" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/arc"))()
         elseif gam == "Playground Basketball" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/Pb"))()
         elseif gam == "Fisch" then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxblast/man/refs/heads/main/fisch"))()
      end
   end,
})
