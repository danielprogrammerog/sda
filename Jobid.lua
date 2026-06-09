-- Bedwars Script mit Onion Labs UI
-- Onion Library laden
local Onion = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnionUI/Onion/main/source"))()

-- ========== ONION WINDOW ERSTELLEN ==========
local Window = Onion:CreateWindow({
    Name = "Bedwars X",
    Center = true,
    Size = UDim2.new(0, 500, 0, 550),
    Theme = "Dark", -- Dark / Light
    Draggable = true
})

-- Tabs
local CombatTab = Window:CreateTab("⚔️ Combat")
local MovementTab = Window:CreateTab("🏃 Movement")
local RenderTab = Window:CreateTab("🎨 Render")
local AutoBuyTab = Window:CreateTab("🛒 AutoBuy")
local UtilityTab = Window:CreateTab("🛠️ Utility")
local ConfigTab = Window:CreateTab("💾 Config")

-- ========== SECTIONS ==========
local CombatSection = CombatTab:CreateSection("Kampf Einstellungen")
local MovementSection = MovementTab:CreateSection("Bewegung")
local RenderSection = RenderTab:CreateSection("Visuals")
local AutoBuySection = AutoBuyTab:CreateSection("Auto-Kauf")
local UtilitySection = UtilityTab:CreateSection("Utility")
local ConfigSection = ConfigTab:CreateSection("Config")

-- ========== STANDARDWERTE ==========
_G.KillAuraEnabled = false
_G.KillAuraRadius = 20
_G.KillAuraDepth = 8
_G.KillAuraDelay = 0.1
_G.AutoClickerEnabled = false
_G.FlyEnabled = false
_G.SpeedEnabled = false
_G.SpiderEnabled = false
_G.ESPEnabled = false
_G.FullbrightEnabled = false
_G.ChamsEnabled = false
_G.AutoBuyEnabled = false
_G.AutoBuyRange = 15
_G.AntiVoidEnabled = false
_G.AutoLeaveEnabled = false

-- AutoBuy Status
_G.OwnedStoneSword = false
_G.OwnedLeatherHelmet = false
_G.OwnedLeatherChestplate = false
_G.OwnedLeatherBoots = false

-- ========== UI ELEMENTE ==========
-- Combat Tab
CombatSection:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(Value)
        _G.KillAuraEnabled = Value
    end
})

CombatSection:CreateSlider({
    Name = "Kill Aura Radius",
    Min = 5,
    Max = 30,
    Default = 20,
    Suffix = "s",
    Callback = function(Value)
        _G.KillAuraRadius = Value
    end
})

CombatSection:CreateSlider({
    Name = "Kill Aura Tiefe (Y-Achse)",
    Min = 2,
    Max = 15,
    Default = 8,
    Suffix = "s",
    Callback = function(Value)
        _G.KillAuraDepth = Value
    end
})

CombatSection:CreateSlider({
    Name = "Angriffsverzögerung",
    Min = 0.05,
    Max = 0.5,
    Default = 0.1,
    Suffix = "s",
    Callback = function(Value)
        _G.KillAuraDelay = Value
    end
})

CombatSection:CreateToggle({
    Name = "AutoClicker (15 CPS)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoClickerEnabled = Value
    end
})

-- Movement Tab
MovementSection:CreateToggle({
    Name = "Fly (NCP Bypass)",
    CurrentValue = false,
    Callback = function(Value)
        _G.FlyEnabled = Value
    end
})

MovementSection:CreateToggle({
    Name = "Speed (50 Walkspeed)",
    CurrentValue = false,
    Callback = function(Value)
        _G.SpeedEnabled = Value
    end
})

MovementSection:CreateToggle({
    Name = "Spider (Wall Climb)",
    CurrentValue = false,
    Callback = function(Value)
        _G.SpiderEnabled = Value
    end
})

-- Render Tab
RenderSection:CreateToggle({
    Name = "ESP (Nametags + Box)",
    CurrentValue = false,
    Callback = function(Value)
        _G.ESPEnabled = Value
    end
})

RenderSection:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        _G.FullbrightEnabled = Value
    end
})

RenderSection:CreateToggle({
    Name = "Chams (Player Glow)",
    CurrentValue = false,
    Callback = function(Value)
        _G.ChamsEnabled = Value
    end
})

-- AutoBuy Tab
AutoBuySection:CreateToggle({
    Name = "AutoBuy aktivieren",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoBuyEnabled = Value
        if Value then
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
        end
    end
})

AutoBuySection:CreateSlider({
    Name = "Shop Reichweite",
    Min = 5,
    Max = 30,
    Default = 15,
    Suffix = "s",
    Callback = function(Value)
        _G.AutoBuyRange = Value
    end
})

AutoBuySection:CreateButton({
    Name = "Reset Gekauft-Status",
    Callback = function()
        _G.OwnedStoneSword = false
        _G.OwnedLeatherHelmet = false
        _G.OwnedLeatherChestplate = false
        _G.OwnedLeatherBoots = false
        Onion:Notify("Status zurückgesetzt!", "AutoBuy")
    end
})

-- Utility Tab
UtilitySection:CreateToggle({
    Name = "AntiVoid (Reset bei Y<0)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AntiVoidEnabled = Value
    end
})

UtilitySection:CreateToggle({
    Name = "Auto Leave (bei Tod)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoLeaveEnabled = Value
    end
})

-- Config Tab
ConfigSection:CreateButton({
    Name = "Config Speichern",
    Callback = function()
        Onion:SaveConfig()
        Onion:Notify("Config gespeichert!", "Config")
    end
})

ConfigSection:CreateButton({
    Name = "Config Laden",
    Callback = function()
        Onion:LoadConfig()
        Onion:Notify("Config geladen!", "Config")
    end
})

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

-- ========== NETWORK PFADE ==========
local SwordHit, SwordSwingMiss, BedwarsPurchaseItem

pcall(function()
    local NetManaged = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged")
    SwordHit = NetManaged:WaitForChild("SwordHit")
    SwordSwingMiss = NetManaged:WaitForChild("SwordSwingMiss")
    BedwarsPurchaseItem = NetManaged:WaitForChild("BedwarsPurchaseItem")
end)

-- ========== WEAPON FINDEN ==========
local function GetCurrentWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item:IsA("Tool") and (item.Name:find("sword") or item.Name:find("Sword")) then
                return item
            end
        end
    end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.Name:find("sword") or item.Name:find("Sword")) then
            return item
        end
    end
    
    return nil
end

-- ========== KILL AURA ==========
local function GetClosestEnemy()
    if not LocalPlayer.Character then return nil end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local shortestDist = _G.KillAuraRadius
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local dist = (hrp.Position - targetHrp.Position).Magnitude
                    local yDiff = math.abs(hrp.Position.Y - targetHrp.Position.Y)
                    if dist <= _G.KillAuraRadius and yDiff <= _G.KillAuraDepth then
                        if dist < shortestDist then
                            shortestDist = dist
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait(_G.KillAuraDelay)
        if _G.KillAuraEnabled and LocalPlayer.Character then
            local weapon = GetCurrentWeapon()
            local target = GetClosestEnemy()
            
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and weapon then
                pcall(function()
                    local args = {{
                        chargedAttack = { chargeRatio = 0 },
                        entityInstance = target.Character,
                        validate = {
                            selfPosition = { value = LocalPlayer.Character.HumanoidRootPart.Position },
                            targetPosition = { value = target.Character.HumanoidRootPart.Position }
                        },
                        weapon = weapon
                    }}
                    if SwordHit then SwordHit:FireServer(unpack(args)) end
                end)
            elseif SwordSwingMiss and weapon then
                pcall(function()
                    local args = {{ weapon = weapon, chargeRatio = 0 }}
                    SwordSwingMiss:FireServer(unpack(args))
                end)
            end
        end
    end
end)

-- ========== AUTO CLICKER ==========
task.spawn(function()
    while true do
        task.wait(1/15)
        if _G.AutoClickerEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            pcall(fireclickdetector)
        end
    end
end)

-- ========== FLY ==========
local FlyBV = nil
local FlyConnection = nil

local function StopFly()
    if FlyBV then FlyBV:Destroy(); FlyBV = nil end
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

local function StartFly()
    StopFly()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    
    FlyBV = Instance.new("BodyVelocity")
    FlyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    FlyBV.Parent = LocalPlayer.Character
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not _G.FlyEnabled or not LocalPlayer.Character then StopFly(); return end
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        FlyBV.Velocity = move * 50
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.FlyEnabled then
            if not FlyBV or not FlyBV.Parent then StartFly() end
        else
            StopFly()
        end
    end
end)

-- ========== SPEED ==========
task.spawn(function()
    while true do
        task.wait(0.3)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            if _G.SpeedEnabled then
                if humanoid.WalkSpeed ~= 50 then humanoid.WalkSpeed = 50 end
            else
                if humanoid.WalkSpeed == 50 then humanoid.WalkSpeed = 16 end
            end
        end
    end
end)

-- ========== SPIDER ==========
task.spawn(function()
    while true do
        task.wait()
        if _G.SpiderEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp then
                if humanoid:GetState() ~= Enum.HumanoidStateType.Falling then
                    humanoid:ChangeState(Enum.HumanoidStateType.Falling)
                end
                hrp.Velocity = hrp.Velocity + Vector3.new(0, 0.1, 0)
            end
        end
        task.wait(0.05)
    end
end)

-- ========== ESP ==========
local ESPObjects = {}
local function ClearESP()
    for _, obj in pairs(ESPObjects) do pcall(function() obj:Destroy() end) end
    ESPObjects = {}
end

task.spawn(function()
    while true do
        ClearESP()
        if _G.ESPEnabled and Workspace.CurrentCamera and LocalPlayer.Character then
            local localHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if localHrp then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                            if onScreen then
                                local dist = (hrp.Position - localHrp.Position).Magnitude
                                local text = Drawing.new("Text")
                                text.Text = player.Name .. " | " .. math.floor(dist) .. "s"
                                text.Color = Color3.new(1, 1, 1)
                                text.Size = 18
                                text.Center = true
                                text.Position = Vector2.new(pos.X, pos.Y - 30)
                                text.Visible = true
                                table.insert(ESPObjects, text)
                                local box = Drawing.new("Square")
                                box.Color = Color3.new(1, 0, 0)
                                box.Thickness = 2
                                box.Filled = false
                                box.Size = Vector2.new(50, 50)
                                box.Position = Vector2.new(pos.X - 25, pos.Y - 25)
                                box.Visible = true
                                table.insert(ESPObjects, box)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ========== FULLBRIGHT ==========
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.FullbrightEnabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.Brightness = 1
        end
    end
end)

-- ========== CHAMS ==========
local ChamsHighlights = {}
local function ClearChams()
    for _, h in pairs(ChamsHighlights) do pcall(function() h:Destroy() end) end
    ChamsHighlights = {}
end

task.spawn(function()
    while true do
        ClearChams()
        if _G.ChamsEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and not part:FindFirstChildOfClass("Highlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Parent = part
                            highlight.Adornee = part
                            highlight.FillColor = Color3.new(1, 0, 0)
                            highlight.OutlineColor = Color3.new(1, 1, 1)
                            highlight.FillTransparency = 0.5
                            table.insert(ChamsHighlights, highlight)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- ========== AUTOBUY ==========
local function GetPlayerResources()
    local resources = { iron = 0, gold = 0 }
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                local amount = item:FindFirstChild("Amount") and item.Amount.Value or 1
                if name:find("iron") then resources.iron = resources.iron + amount
                elseif name:find("gold") then resources.gold = resources.gold + amount end
            end
        end
    end
    return resources
end

local function IsNearShop()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name and (obj.Name:find("Shop") or obj.Name:find("ItemShop")) then
            local shopPos = obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or (obj:IsA("BasePart") and obj.Position)
            if shopPos and (hrp.Position - shopPos).Magnitude <= _G.AutoBuyRange then return true end
        end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoBuyEnabled and BedwarsPurchaseItem and IsNearShop() then
            local resources = GetPlayerResources()
            
            if not _G.OwnedStoneSword and resources.iron >= 20 then
                pcall(function()
                    local args = {{
                        shopItem = { itemType = "stone_sword", price = 20, currency = "iron", amount = 1, category = "Combat" },
                        shopId = "1_item_shop"
                    }}
                    BedwarsPurchaseItem:InvokeServer(unpack(args))
                    _G.OwnedStoneSword = true
                    Onion:Notify("Steinschwert gekauft!", "AutoBuy")
                end)
            end
            
            if not _G.OwnedLeatherHelmet and resources.iron >= 50 then
                pcall(function()
                    local args = {{
                        shopItem = { itemType = "leather_helmet", price = 50, currency = "iron", amount = 1, category = "Combat" },
                        shopId = "1_item_shop"
                    }}
                    BedwarsPurchaseItem:InvokeServer(unpack(args))
                    _G.OwnedLeatherHelmet = true
                end)
            end
            
            if not _G.OwnedLeatherChestplate and resources.iron >= 50 then
                pcall(function()
                    local args = {{
                        shopItem = { itemType = "leather_chestplate", price = 50, currency = "iron", amount = 1, category = "Combat" },
                        shopId = "1_item_shop"
                    }}
                    BedwarsPurchaseItem:InvokeServer(unpack(args))
                    _G.OwnedLeatherChestplate = true
                end)
            end
            
            if not _G.OwnedLeatherBoots and resources.iron >= 50 then
                pcall(function()
                    local args = {{
                        shopItem = { itemType = "leather_boots", price = 50, currency = "iron", amount = 1, category = "Combat" },
                        shopId = "1_item_shop"
                    }}
                    BedwarsPurchaseItem:InvokeServer(unpack(args))
                    _G.OwnedLeatherBoots = true
                end)
            end
        end
    end
end)

-- ========== ANTIVOID ==========
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AntiVoidEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character.HumanoidRootPart.Position.Y < -10 then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then humanoid.Health = 0 end
            end
        end
    end
end)

-- ========== AUTO LEAVE ==========
local function SetupAutoLeave()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            if _G.AutoLeaveEnabled then
                task.wait(1)
                TeleportService:Teleport(game.PlaceId)
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    SetupAutoLeave()
end)
SetupAutoLeave()

-- ========== HOTKEYS ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        Window:Toggle()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        _G.KillAuraEnabled = not _G.KillAuraEnabled
        Onion:Notify("Kill Aura: " .. (_G.KillAuraEnabled and "AN" or "AUS"), "Combat")
    elseif input.KeyCode == Enum.KeyCode.F7 then
        _G.AutoBuyEnabled = not _G.AutoBuyEnabled
        Onion:Notify("AutoBuy: " .. (_G.AutoBuyEnabled and "AN" or "AUS"), "AutoBuy")
    elseif input.KeyCode == Enum.KeyCode.F8 then
        _G.FlyEnabled = not _G.FlyEnabled
        Onion:Notify("Fly: " .. (_G.FlyEnabled and "AN" or "AUS"), "Movement")
    elseif input.KeyCode == Enum.KeyCode.F9 then
        _G.SpeedEnabled = not _G.SpeedEnabled
        Onion:Notify("Speed: " .. (_G.SpeedEnabled and "AN" or "AUS"), "Movement")
    elseif input.KeyCode == Enum.KeyCode.F10 then
        _G.ESPEnabled = not _G.ESPEnabled
        Onion:Notify("ESP: " .. (_G.ESPEnabled and "AN" or "AUS"), "Render")
    elseif input.KeyCode == Enum.KeyCode.F11 then
        _G.FullbrightEnabled = not _G.FullbrightEnabled
        Onion:Notify("Fullbright: " .. (_G.FullbrightEnabled and "AN" or "AUS"), "Render")
    end
end)

Onion:Notify("Bedwars Script geladen! F5 = UI umschalten", "Willkommen")
print("Bedwars Script mit Onion Labs geladen! Drücke F5 für UI")