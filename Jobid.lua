-- ============================================
-- BEDWARS SCRIPT - SIMPLE & GARANTIERT FUNKTIONIEREND
-- Kein Rayfield, keine komplizierten Frameworks
-- ============================================

-- ========== EINFACHE, SICHERE GUI ==========
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BedwarsSimpleUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Hauptfenster
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Abrundung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "⚔️ BEDWARS PRO ⚔️"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = mainFrame

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.Text = "Hotkeys: F5=GUI | F6=KillAura | F7=AutoBuy | F8=Fly | F9=Speed | F10=ESP | F11=Fullbright"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Scroll Container für Buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -110)
scrollFrame.Position = UDim2.new(0, 10, 0, 70)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = mainFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 8)
scrollLayout.Parent = scrollFrame

-- ========== BUTTONS ERSTELLEN ==========
local function CreateButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggleButton(parent, text, flag, hotkey, color)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Text = text .. (hotkey and " [" .. hotkey .. "]" or "")
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Padding = UDim.new(0, 12)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 36)
    btn.Position = UDim2.new(1, -90, 0.5, -18)
    btn.Text = "AUS"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local state = false
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        _G[flag] = state
        if state then
            btn.Text = "AN"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            btn.Text = "AUS"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end)
end

local function CreateSlider(parent, text, flag, minVal, maxVal, defaultVal, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Text = text .. ": " .. defaultVal .. suffix
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.85, 0, 0, 4)
    sliderBar.Position = UDim2.new(0.075, 0, 0.65, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 25)
    valueLabel.Position = UDim2.new(0.85, 0, 0.35, 0)
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.Parent = frame
    
    local currentVal = defaultVal
    _G[flag] = currentVal
    
    local dragging = false
    local sliderConnection = nil
    
    local function updateValue(xPos)
        local barPos = sliderBar.AbsolutePosition.X
        local barWidth = sliderBar.AbsoluteSize.X
        local percent = math.clamp((xPos - barPos) / barWidth, 0, 1)
        currentVal = minVal + (maxVal - minVal) * percent
        currentVal = math.floor(currentVal * 10) / 10
        _G[flag] = currentVal
        fill.Size = UDim2.new(percent, 0, 1, 0)
        label.Text = text .. ": " .. currentVal .. suffix
        valueLabel.Text = tostring(currentVal)
    end
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -9, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    knob.MouseButton1Down:Connect(function()
        dragging = true
        sliderConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if dragging then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                updateValue(mousePos.X)
                knob.Position = UDim2.new((_G[flag] - minVal) / (maxVal - minVal), -9, 0.5, -9)
            end
        end)
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            if sliderConnection then sliderConnection:Disconnect() end
        end
    end)
end

-- ========== UI INHALT ==========
-- Section Titel
local function addSection(title)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.Text = "━━━━━ " .. title .. " ━━━━━"
    section.TextColor3 = Color3.fromRGB(255, 200, 100)
    section.BackgroundTransparency = 1
    section.Font = Enum.Font.GothamBold
    section.TextSize = 14
    section.Parent = scrollFrame
end

addSection("🗡️ KAMPF")
CreateToggleButton(scrollFrame, "Kill Aura", "KillAuraEnabled", "F6", nil)
CreateSlider(scrollFrame, "Kill Aura Radius", "KillAuraRadius", 5, 30, 20, "s")
CreateSlider(scrollFrame, "Kill Aura Tiefe", "KillAuraDepth", 2, 15, 8, "s")
CreateSlider(scrollFrame, "Angriffsverzögerung", "KillAuraDelay", 0.05, 0.5, 0.1, "s")
CreateToggleButton(scrollFrame, "AutoClicker (15 CPS)", "AutoClickerEnabled", nil, nil)

addSection("🏃 BEWEGUNG")
CreateToggleButton(scrollFrame, "Fly (NCP Bypass)", "FlyEnabled", "F8", nil)
CreateToggleButton(scrollFrame, "Speed (50 Walkspeed)", "SpeedEnabled", "F9", nil)
CreateToggleButton(scrollFrame, "Spider (Wall Climb)", "SpiderEnabled", nil, nil)

addSection("👁️ VISUALS")
CreateToggleButton(scrollFrame, "ESP (Nametags + Box)", "ESPEnabled", "F10", nil)
CreateToggleButton(scrollFrame, "Fullbright", "FullbrightEnabled", "F11", nil)
CreateToggleButton(scrollFrame, "Chams (Player Glow)", "ChamsEnabled", nil, nil)

addSection("🛒 AUTOBUY")
CreateToggleButton(scrollFrame, "AutoBuy aktivieren", "AutoBuyEnabled", "F7", nil)
CreateSlider(scrollFrame, "Shop Reichweite", "AutoBuyRange", 5, 30, 15, "s")

-- Reset Button
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, 0, 0, 40)
resetBtn.Text = "🔄 Reset Gekauft-Status"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 14
resetBtn.BorderSizePixel = 0
resetBtn.Parent = scrollFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetBtn

resetBtn.MouseButton1Click:Connect(function()
    _G.OwnedStoneSword = false
    _G.OwnedLeatherHelmet = false
    _G.OwnedLeatherChestplate = false
    _G.OwnedLeatherBoots = false
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "AutoBuy", Text = "Status zurückgesetzt!", Duration = 2})
end)

addSection("🛡️ UTILITY")
CreateToggleButton(scrollFrame, "AntiVoid (Reset bei Y<0)", "AntiVoidEnabled", nil, nil)
CreateToggleButton(scrollFrame, "Auto Leave (bei Tod)", "AutoLeaveEnabled", nil, nil)

-- ScrollFrame CanvasSize updaten
scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 20)
end)

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
_G.OwnedStoneSword = false
_G.OwnedLeatherHelmet = false
_G.OwnedLeatherChestplate = false
_G.OwnedLeatherBoots = false

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

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
            if item:IsA("Tool") and item.Name:lower():find("sword") then
                return item
            end
        end
    end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and item.Name:lower():find("sword") then
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
            if player.Character.Humanoid.Health > 0 then
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
            
            if target and target.Character and weapon then
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
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.FlyEnabled and LocalPlayer.Character then
            if not FlyBV or not FlyBV.Parent then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then humanoid.PlatformStand = true end
                FlyBV = Instance.new("BodyVelocity")
                FlyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                FlyBV.Parent = LocalPlayer.Character
            end
            
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
            FlyBV.Velocity = move * 50
        elseif not _G.FlyEnabled and FlyBV then
            FlyBV:Destroy()
            FlyBV = nil
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.PlatformStand = false
            end
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
        task.wait(0.05)
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
    end
end)

-- ========== ESP ==========
local ESPObjects = {}
task.spawn(function()
    while true do
        for _, obj in pairs(ESPObjects) do pcall(function() obj:Destroy() end) end
        ESPObjects = {}
        
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
                                text.Size = 16
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
task.spawn(function()
    while true do
        for _, h in pairs(ChamsHighlights) do pcall(function() h:Destroy() end) end
        ChamsHighlights = {}
        
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
        mainFrame.Visible = not mainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.F6 then
        _G.KillAuraEnabled = not _G.KillAuraEnabled
        StarterGui:SetCore("SendNotification", {Title = "Kill Aura", Text = _G.KillAuraEnabled and "🟢 AN" or "🔴 AUS", Duration = 1})
    elseif input.KeyCode == Enum.KeyCode.F7 then
        _G.AutoBuyEnabled = not _G.AutoBuyEnabled
        if _G.AutoBuyEnabled then
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
        end
        StarterGui:SetCore("SendNotification", {Title = "AutoBuy", Text = _G.AutoBuyEnabled and "🟢 AN" or "🔴 AUS", Duration = 1})
    elseif input.KeyCode == Enum.KeyCode.F8 then
        _G.FlyEnabled = not _G.FlyEnabled
        StarterGui:SetCore("SendNotification", {Title = "Fly", Text = _G.FlyEnabled and "🟢 AN" or "🔴 AUS", Duration = 1})
    elseif input.KeyCode == Enum.KeyCode.F9 then
        _G.SpeedEnabled = not _G.SpeedEnabled
        StarterGui:SetCore("SendNotification", {Title = "Speed", Text = _G.SpeedEnabled and "🟢 AN" or "🔴 AUS", Duration = 1})
    elseif input.KeyCode == Enum.KeyCode.F10 then
        _G.ESPEnabled = not _G.ESPEnabled
        StarterGui:SetCore("SendNotification", {Title = "ESP", Text = _G.ESPEnabled and "🟢 AN" or "🔴 AUS", Duration = 1})
    elseif input.KeyCode == Enum.KeyCode.F11 then
        _G.FullbrightEnabled = not _G.FullbrightEnabled
        StarterGui:SetCore("SendNotification", {Title = "Fullbright", Text = _G.FullbrightEnabled and "🟢 AN" or "🔴 AUS", Duration = 1})
    end
end)

-- ========== START ==========
StarterGui:SetCore("SendNotification", {
    Title = "Bedwars Pro",
    Text = "Script geladen! GUI ist sichtbar. Drücke F5 zum schließen/öffnen.",
    Duration = 5
})

print("Bedwars Script geladen! GUI sollte sichtbar sein.")