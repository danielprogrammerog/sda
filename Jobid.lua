-- Bedwars Complete Script - GEFIXT
-- Bugs behoben: ESP, AutoBuy, Fly, Speed, Chams, AutoLeave, Weapon

-- ========== GUI ERSTELLEN ==========
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BedwarsGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Hauptfenster
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔥 BEDWARS SCRIPT 🔥"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.Text = "Alle Features | Hotkeys: F6-F11 | F5 = GUI"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.Parent = mainFrame

-- Tabs Container
local tabsContainer = Instance.new("Frame")
tabsContainer.Size = UDim2.new(1, 0, 0, 40)
tabsContainer.Position = UDim2.new(0, 0, 0, 70)
tabsContainer.BackgroundTransparency = 1
tabsContainer.Parent = mainFrame

-- Scroll Container für Tab-Inhalte
local scrollContainer = Instance.new("ScrollingFrame")
scrollContainer.Size = UDim2.new(1, -20, 1, -130)
scrollContainer.Position = UDim2.new(0, 10, 0, 115)
scrollContainer.BackgroundTransparency = 1
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollContainer.ScrollBarThickness = 5
scrollContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = scrollContainer

-- Schließen-Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ========== HELFER-FUNKTIONEN ==========
local function CreateToggle(parent, name, flag, color, hotkey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = name .. (hotkey and " [" .. hotkey .. "]" or "")
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Padding = UDim.new(0, 10)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 30)
    button.Position = UDim2.new(1, -90, 0.5, -15)
    button.Text = "AUS"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = frame
    
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 6)
    corner3.Parent = button
    
    local state = _G[flag] or false
    if state then
        button.Text = "AN"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    end
    
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            button.Text = "AN"
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            button.Text = "AUS"
            button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        _G[flag] = state
    end)
    
    return button
end

local function CreateSlider(parent, name, flag, min, max, default, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 65)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Text = name .. ": " .. tostring(default) .. suffix
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.9, 0, 0, 4)
    slider.Position = UDim2.new(0.05, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = slider
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local value = default
    _G[flag] = value
    
    local dragging = false
    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local sliderPos = slider.AbsolutePosition.X
            local sliderWidth = slider.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - sliderPos) / sliderWidth, 0, 1)
            value = min + (max - min) * percent
            value = math.floor(value * 10) / 10
            _G[flag] = value
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -8, 0.5, -8)
            label.Text = name .. ": " .. tostring(value) .. suffix
        end
    end)
end

-- Tabs erstellen
local tabs = {"Combat", "Movement", "Render", "AutoBuy", "Utility"}
local currentTab = nil
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.2, -2, 1, -4)
    tabBtn.Position = UDim2.new((i-1) * 0.2, 2, 0, 2)
    tabBtn.Text = tabName
    tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.Parent = tabsContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 5
    tabContent.Visible = false
    tabContent.Parent = scrollContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = tabContent
    
    tabContents[tabName] = tabContent
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, content in pairs(tabContents) do
            content.Visible = false
        end
        for _, btn in pairs(tabsContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            end
        end
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    end)
    
    if i == 1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        tabContent.Visible = true
    end
    
    -- Tab Inhalte
    if tabName == "Combat" then
        CreateToggle(tabContent, "Kill Aura (20s Radius, 8s Tiefe)", "KillAuraEnabled", nil, "F6")
        CreateSlider(tabContent, "Kill Aura Radius", "KillAuraRadius", 5, 30, 20, "s")
        CreateSlider(tabContent, "Kill Aura Tiefe", "KillAuraDepth", 2, 15, 8, "s")
        CreateSlider(tabContent, "Angriffsverzögerung", "KillAuraDelay", 0.05, 0.5, 0.1, "s")
        CreateToggle(tabContent, "AutoClicker (15 CPS)", "AutoClickerEnabled", nil, nil)
    elseif tabName == "Movement" then
        CreateToggle(tabContent, "Fly (NCP Bypass)", "FlyEnabled", nil, "F8")
        CreateToggle(tabContent, "Speed (50 Walkspeed)", "SpeedEnabled", nil, "F9")
        CreateToggle(tabContent, "Spider (Wall Climb)", "SpiderEnabled", nil, nil)
    elseif tabName == "Render" then
        CreateToggle(tabContent, "ESP (Nametags + Box)", "ESPEnabled", nil, "F10")
        CreateToggle(tabContent, "Fullbright", "FullbrightEnabled", nil, "F11")
        CreateToggle(tabContent, "Chams (Player Glow)", "ChamsEnabled", nil, nil)
    elseif tabName == "AutoBuy" then
        CreateToggle(tabContent, "AutoBuy aktivieren", "AutoBuyEnabled", nil, "F7")
        CreateSlider(tabContent, "Shop Reichweite", "AutoBuyRange", 5, 30, 15, "s")
        
        local resetBtn = Instance.new("TextButton")
        resetBtn.Size = UDim2.new(1, -10, 0, 40)
        resetBtn.Text = "🔄 Reset Gekauft-Status"
        resetBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
        resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 14
        resetBtn.Parent = tabContent
        
        local resetCorner = Instance.new("UICorner")
        resetCorner.CornerRadius = UDim.new(0, 8)
        resetCorner.Parent = resetBtn
        
        resetBtn.MouseButton1Click:Connect(function()
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
            _G.OwnedIronSword = false
            _G.OwnedIronHelmet = false
            _G.OwnedIronChestplate = false
            _G.OwnedIronBoots = false
        end)
    elseif tabName == "Utility" then
        CreateToggle(tabContent, "AntiVoid (Reset bei Y<0)", "AntiVoidEnabled", nil, nil)
        CreateToggle(tabContent, "Auto Leave (bei Tod)", "AutoLeaveEnabled", nil, nil)
    end
end

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
_G.OwnedIronSword = false
_G.OwnedIronHelmet = false
_G.OwnedIronChestplate = false
_G.OwnedIronBoots = false

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
local SwordHit = nil
local SwordSwingMiss = nil
local BedwarsPurchaseItem = nil
local SetInvItem = nil
local SetArmorInvItem = nil

pcall(function()
    local NetManaged = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged")
    SwordHit = NetManaged:WaitForChild("SwordHit")
    SwordSwingMiss = NetManaged:WaitForChild("SwordSwingMiss")
    BedwarsPurchaseItem = NetManaged:WaitForChild("BedwarsPurchaseItem")
    SetInvItem = NetManaged:WaitForChild("SetInvItem")
    SetArmorInvItem = NetManaged:WaitForChild("SetArmorInvItem")
end)

-- ========== WEAPON FINDEN ==========
local function GetCurrentWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    -- Erstes Schwert im Inventar finden
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item:IsA("Tool") and (item.Name:find("sword") or item.Name:find("Sword")) then
                return item
            end
        end
    end
    
    -- Im Charakter suchen
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
                    if SwordHit then
                        SwordHit:FireServer(unpack(args))
                    end
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
    if FlyBV then
        FlyBV:Destroy()
        FlyBV = nil
    end
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

local function StartFly()
    StopFly()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    FlyBV = Instance.new("BodyVelocity")
    FlyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    FlyBV.Parent = LocalPlayer.Character
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not _G.FlyEnabled or not LocalPlayer.Character then
            StopFly()
            return
        end
        if not FlyBV or not FlyBV.Parent then
            StartFly()
            return
        end
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
            if not FlyBV or not FlyBV.Parent then
                StartFly()
            end
        else
            StopFly()
        end
    end
end)

-- ========== SPEED ==========
task.spawn(function()
    local originalSpeed = 16
    while true do
        task.wait(0.3)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            if _G.SpeedEnabled then
                if humanoid.WalkSpeed ~= 50 then
                    humanoid.WalkSpeed = 50
                end
            else
                if humanoid.WalkSpeed == 50 then
                    humanoid.WalkSpeed = originalSpeed
                end
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
    for _, obj in pairs(ESPObjects) do
        pcall(function() obj:Destroy() end)
    end
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
    local originalAmbient = Lighting.Ambient
    local originalBrightness = Lighting.Brightness
    
    while true do
        task.wait(0.3)
        if _G.FullbrightEnabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = originalAmbient
            Lighting.Brightness = originalBrightness
        end
    end
end)

-- ========== CHAMS ==========
local ChamsHighlights = {}
local function ClearChams()
    for _, h in pairs(ChamsHighlights) do
        pcall(function() h:Destroy() end)
    end
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
    local resources = { iron = 0, gold = 0, diamond = 0, emerald = 0 }
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                local amount = 1
                if item:FindFirstChild("Amount") then
                    amount = item.Amount.Value
                end
                if name:find("iron") then
                    resources.iron = resources.iron + amount
                elseif name:find("gold") then
                    resources.gold = resources.gold + amount
                elseif name:find("diamond") then
                    resources.diamond = resources.diamond + amount
                elseif name:find("emerald") then
                    resources.emerald = resources.emerald + amount
                end
            end
        end
    end
    return resources
end

local function IsNearShop()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name and (obj.Name:find("Shop") or obj.Name:find("ItemShop") or obj.Name:find("ShopStand")) then
            local shopPos = obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or (obj:IsA("BasePart") and obj.Position)
            if shopPos and (hrp.Position - shopPos).Magnitude <= _G.AutoBuyRange then
                return true
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoBuyEnabled and BedwarsPurchaseItem and IsNearShop() then
            local resources = GetPlayerResources()
            
            -- Steinschwert kaufen
            if not _G.OwnedStoneSword and resources.iron >= 20 then
                pcall(function()
                    local args = {{
                        shopItem = {
                            itemType = "stone_sword",
                            price = 20,
                            currency = "iron",
                            amount = 1,
                            category = "Combat"
                        },
                        shopId = "1_item_shop"
                    }}
                    BedwarsPurchaseItem:InvokeServer(unpack(args))
                    _G.OwnedStoneSword = true
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "AutoBuy", Text = "Steinschwert gekauft!", Duration = 2
                    })
                end)
            end
            
            -- Leder Rüstung kaufen
            if not _G.OwnedLeatherHelmet and resources.iron >= 50 then
                pcall(function()
                    local args = {{
                        shopItem = {
                            itemType = "leather_helmet",
                            price = 50,
                            currency = "iron",
                            amount = 1,
                            category = "Combat"
                        },
                        shopId = "1_item_shop"
                    }}
                    BedwarsPurchaseItem:InvokeServer(unpack(args))
                    _G.OwnedLeatherHelmet = true
                end)
            end
            
            if not _G.OwnedLeatherChestplate and resources.iron >= 50 then
                pcall(function()
                    local args = {{
                        shopItem = {
                            itemType = "leather_chestplate",
                            price = 50,
                            currency = "iron",
                            amount = 1,
                            category = "Combat"
                        },
                        shopId = "1_item_shop"
                    }}
                    BedwarsPurchaseItem:InvokeServer(unpack(args))
                    _G.OwnedLeatherChestplate = true
                end)
            end
            
            if not _G.OwnedLeatherBoots and resources.iron >= 50 then
                pcall(function()
                    local args = {{
                        shopItem = {
                            itemType = "leather_boots",
                            price = 50,
                            currency = "iron",
                            amount = 1,
                            category = "Combat"
                        },
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
                if humanoid then
                    humanoid.Health = 0
                end
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

-- Bei Charakter-Reset neu verbinden
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    SetupAutoLeave()
end)
SetupAutoLeave()

-- ========== HOTKEYS ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        mainFrame.Visible = not mainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.F6 then        _G.KillAuraEnabled = not _G.KillAuraEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Kill Aura", Text = _G.KillAuraEnabled and "🟢 AN" or "🔴 AUS", Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F7 then
        _G.AutoBuyEnabled = not _G.AutoBuyEnabled
        if _G.AutoBuyEnabled then
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "AutoBuy", Text = _G.AutoBuyEnabled and "🟢 AN" or "🔴 AUS", Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F8 then
        _G.FlyEnabled = not _G.FlyEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fly", Text = _G.FlyEnabled and "🟢 AN" or "🔴 AUS", Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F9 then
        _G.SpeedEnabled = not _G.SpeedEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Speed", Text = _G.SpeedEnabled and "🟢 AN" or "🔴 AUS", Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F10 then
        _G.ESPEnabled = not _G.ESPEnabled
        if not _G.ESPEnabled then ClearESP() end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ESP", Text = _G.ESPEnabled and "🟢 AN" or "🔴 AUS", Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F11 then
        _G.FullbrightEnabled = not _G.FullbrightEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fullbright", Text = _G.FullbrightEnabled and "🟢 AN" or "🔴 AUS", Duration = 1
        })
    end
end)

print("Bedwars Script geladen! Drücke F5 für GUI | F6-F11 für Toggles")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Bedwars Script", Text = "Geladen! F5 = GUI", Duration = 3
})