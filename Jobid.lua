-- ONION LABS UI - BEDWARS SCRIPT
-- Korrekter Onion Labs Loadstring

local Onion = nil

-- Onion Labs korrekt laden
local Success, Error = pcall(function()
    Onion = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnionUI/Onion/main/source"))()
end)

if not Success or not Onion then
    -- Fallback: Versuche alternative Onion URL
    local Success2, Error2 = pcall(function()
        Onion = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnionUI/Onion/master/source.lua"))()
    end)
    
    if not Success2 or not Onion then
        -- Wenn Onion nicht lädt, benachrichtigen
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Onion Labs Fehler",
            Text = "Konnte Onion nicht laden. Verwende trotzdem alle Features (Hotkeys F6-F11)",
            Duration = 5
        })
        
        -- Erstelle trotzdem ein einfaches GUI
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "BedwarsGUI"
        screenGui.Parent = game:GetService("PlayerGui").LocalPlayer
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 400, 0, 500)
        mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        mainFrame.BackgroundTransparency = 0.1
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.Text = "⚔️ BEDWARS SCRIPT ⚔️"
        title.TextColor3 = Color3.fromRGB(255, 100, 100)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.Parent = mainFrame
        
        local subtitle = Instance.new("TextLabel")
        subtitle.Size = UDim2.new(1, 0, 0, 25)
        subtitle.Position = UDim2.new(0, 0, 0, 45)
        subtitle.Text = "Onion Labs nicht verfügbar | Hotkeys: F5=GUI F6=KillAura F7=AutoBuy F8=Fly F9=Speed F10=ESP F11=Fullbright"
        subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
        subtitle.BackgroundTransparency = 1
        subtitle.Font = Enum.Font.Gotham
        subtitle.TextSize = 11
        subtitle.Parent = mainFrame
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 5)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18
        closeBtn.Parent = mainFrame
        
        closeBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = not mainFrame.Visible
        end)
        
        _G.OnionFallback = true
        _G.OnionFrame = mainFrame
    end
end

-- Wenn Onion erfolgreich geladen wurde
if Onion then
    _G.OnionFallback = false
    
    -- Onion Window erstellen
    local Window = Onion:CreateWindow({
        Name = "⚔️ BEDWARS X ⚔️",
        Center = true,
        Size = UDim2.new(0, 520, 0, 580),
        Theme = "Dark",
        Draggable = true,
        Minimizable = true
    })
    
    -- ========== TABS ==========
    local MainTab = Window:CreateTab("🏠 Main")
    local CombatTab = Window:CreateTab("⚔️ Combat")
    local MovementTab = Window:CreateTab("🏃 Movement")
    local VisualTab = Window:CreateTab("👁️ Visuals")
    local AutoBuyTab = Window:CreateTab("🛒 AutoBuy")
    local UtilityTab = Window:CreateTab("🛠️ Utility")
    local SettingsTab = Window:CreateTab("⚙️ Settings")
    
    -- ========== MAIN TAB ==========
    local MainSection = MainTab:CreateSection("📊 Status")
    
    MainSection:CreateLabel("Willkommen beim Bedwars Script!")
    MainSection:CreateLabel("Alle Features sind über die Tabs erreichbar")
    MainSection:CreateLabel("Hotkeys: F5 = UI umschalten")
    MainSection:CreateLabel("")
    MainSection:CreateLabel("📌 Aktive Features:")
    MainSection:CreateLabel("  • Kill Aura (Radius/Tiefe einstellbar)")
    MainSection:CreateLabel("  • AutoClicker (15 CPS)")
    MainSection:CreateLabel("  • Fly (NCP Bypass)")
    MainSection:CreateLabel("  • Speed (50 Walkspeed)")
    MainSection:CreateLabel("  • Spider (Wall Climb)")
    MainSection:CreateLabel("  • ESP (Nametags + Box)")
    MainSection:CreateLabel("  • Fullbright")
    MainSection:CreateLabel("  • Chams (Player Glow)")
    MainSection:CreateLabel("  • AutoBuy (Schwert + Rüstung)")
    MainSection:CreateLabel("  • AntiVoid")
    MainSection:CreateLabel("  • Auto Leave")
    
    -- ========== COMBAT TAB ==========
    local CombatSection = CombatTab:CreateSection("🗡️ Kill Aura")
    
    CombatSection:CreateToggle({
        Name = "Kill Aura aktivieren",
        CurrentValue = false,
        Callback = function(Value)
            _G.KillAuraEnabled = Value
            Onion:Notify("Kill Aura " .. (Value and "aktiviert" or "deaktiviert"), "Combat")
        end
    })
    
    CombatSection:CreateSlider({
        Name = "Kill Aura Radius",
        Min = 5,
        Max = 30,
        Default = 20,
        Suffix = " Studs",
        Callback = function(Value)
            _G.KillAuraRadius = Value
        end
    })
    
    CombatSection:CreateSlider({
        Name = "Kill Aura Tiefe (Y-Achse)",
        Min = 2,
        Max = 15,
        Default = 8,
        Suffix = " Studs",
        Callback = function(Value)
            _G.KillAuraDepth = Value
        end
    })
    
    CombatSection:CreateSlider({
        Name = "Angriffsverzögerung",
        Min = 0.05,
        Max = 0.5,
        Default = 0.1,
        Suffix = " Sekunden",
        Callback = function(Value)
            _G.KillAuraDelay = Value
        end
    })
    
    CombatSection:CreateDivider()
    
    local AutoClickerSection = CombatTab:CreateSection("🖱️ AutoClicker")
    
    AutoClickerSection:CreateToggle({
        Name = "AutoClicker (15 CPS)",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoClickerEnabled = Value
            Onion:Notify("AutoClicker " .. (Value and "aktiviert" or "deaktiviert"), "Combat")
        end
    })
    
    -- ========== MOVEMENT TAB ==========
    local MovementSection = MovementTab:CreateSection("🕊️ Flight")
    
    MovementSection:CreateToggle({
        Name = "Fly (NCP Bypass)",
        CurrentValue = false,
        Callback = function(Value)
            _G.FlyEnabled = Value
            Onion:Notify("Fly " .. (Value and "aktiviert" or "deaktiviert"), "Movement")
        end
    })
    
    MovementSection:CreateDivider()
    
    local SpeedSection = MovementTab:CreateSection("💨 Speed")
    
    SpeedSection:CreateToggle({
        Name = "Speed (50 Walkspeed)",
        CurrentValue = false,
        Callback = function(Value)
            _G.SpeedEnabled = Value
            Onion:Notify("Speed " .. (Value and "aktiviert" or "deaktiviert"), "Movement")
        end
    })
    
    MovementSection:CreateDivider()
    
    local SpiderSection = MovementTab:CreateSection("🕷️ Spider")
    
    SpiderSection:CreateToggle({
        Name = "Spider (Wall Climb)",
        CurrentValue = false,
        Callback = function(Value)
            _G.SpiderEnabled = Value
            Onion:Notify("Spider " .. (Value and "aktiviert" or "deaktiviert"), "Movement")
        end
    })
    
    -- ========== VISUAL TAB ==========
    local ESP_Section = VisualTab:CreateSection("👁️ ESP")
    
    ESP_Section:CreateToggle({
        Name = "ESP (Nametags + Box)",
        CurrentValue = false,
        Callback = function(Value)
            _G.ESPEnabled = Value
            Onion:Notify("ESP " .. (Value and "aktiviert" or "deaktiviert"), "Visuals")
        end
    })
    
    ESP_Section:CreateDivider()
    
    local BrightSection = VisualTab:CreateSection("💡 Brightness")
    
    BrightSection:CreateToggle({
        Name = "Fullbright",
        CurrentValue = false,
        Callback = function(Value)
            _G.FullbrightEnabled = Value
            Onion:Notify("Fullbright " .. (Value and "aktiviert" or "deaktiviert"), "Visuals")
        end
    })
    
    ESP_Section:CreateDivider()
    
    local ChamsSection = VisualTab:CreateSection("✨ Chams")
    
    ChamsSection:CreateToggle({
        Name = "Chams (Player Glow)",
        CurrentValue = false,
        Callback = function(Value)
            _G.ChamsEnabled = Value
            Onion:Notify("Chams " .. (Value and "aktiviert" or "deaktiviert"), "Visuals")
        end
    })
    
    -- ========== AUTOBUY TAB ==========
    local AutoBuySection = AutoBuyTab:CreateSection("🛒 AutoBuy Einstellungen")
    
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
            Onion:Notify("AutoBuy " .. (Value and "aktiviert" or "deaktiviert"), "AutoBuy")
        end
    })
    
    AutoBuySection:CreateSlider({
        Name = "Shop Reichweite",
        Min = 5,
        Max = 30,
        Default = 15,
        Suffix = " Studs",
        Callback = function(Value)
            _G.AutoBuyRange = Value
        end
    })
    
    AutoBuySection:CreateDivider()
    
    AutoBuySection:CreateLabel("📦 Gekaufte Items:")
    AutoBuySection:CreateLabel("  • Steinschwert (20 Eisen)")
    AutoBuySection:CreateLabel("  • Lederhelm (50 Eisen)")
    AutoBuySection:CreateLabel("  • Lederbrustplatte (50 Eisen)")
    AutoBuySection:CreateLabel("  • Lederstiefel (50 Eisen)")
    
    AutoBuySection:CreateDivider()
    
    AutoBuySection:CreateButton({
        Name = "🔄 Reset Gekauft-Status",
        Callback = function()
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
            Onion:Notify("Status zurückgesetzt! Items können erneut gekauft werden", "AutoBuy")
        end
    })
    
    -- ========== UTILITY TAB ==========
    local AntiVoidSection = UtilityTab:CreateSection("🛡️ Schutz")
    
    AntiVoidSection:CreateToggle({
        Name = "AntiVoid (Reset bei Y<0)",
        CurrentValue = false,
        Callback = function(Value)
            _G.AntiVoidEnabled = Value
            Onion:Notify("AntiVoid " .. (Value and "aktiviert" or "deaktiviert"), "Utility")
        end
    })
    
    AntiVoidSection:CreateDivider()
    
    local LeaveSection = UtilityTab:CreateSection("🚪 Auto Leave")
    
    LeaveSection:CreateToggle({
        Name = "Auto Leave (bei Tod)",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoLeaveEnabled = Value
            Onion:Notify("Auto Leave " .. (Value and "aktiviert" or "deaktiviert"), "Utility")
        end
    })
    
    -- ========== SETTINGS TAB ==========
    local ConfigSection = SettingsTab:CreateSection("💾 Config")
    
    ConfigSection:CreateButton({
        Name = "💾 Config Speichern",
        Callback = function()
            Onion:SaveConfig()
            Onion:Notify("Config gespeichert!", "Settings")
        end
    })
    
    ConfigSection:CreateButton({
        Name = "📂 Config Laden",
        Callback = function()
            Onion:LoadConfig()
            Onion:Notify("Config geladen!", "Settings")
        end
    })
    
    ConfigSection:CreateDivider()
    
    local HotkeySection = SettingsTab:CreateSection("⌨️ Hotkeys")
    
    HotkeySection:CreateLabel("F5 - UI ein-/ausblenden")
    HotkeySection:CreateLabel("F6 - Kill Aura ein-/aus")
    HotkeySection:CreateLabel("F7 - AutoBuy ein-/aus")
    HotkeySection:CreateLabel("F8 - Fly ein-/aus")
    HotkeySection:CreateLabel("F9 - Speed ein-/aus")
    HotkeySection:CreateLabel("F10 - ESP ein-/aus")
    HotkeySection:CreateLabel("F11 - Fullbright ein-/aus")
    
    -- Start-Notiz
    Onion:Notify("Bedwars Script geladen! Drücke F5 für UI", "Willkommen")
end

-- ========== HAUPTFUNKTIONEN (immer aktiv) ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

-- Standardwerte setzen
_G.KillAuraEnabled = _G.KillAuraEnabled or false
_G.KillAuraRadius = _G.KillAuraRadius or 20
_G.KillAuraDepth = _G.KillAuraDepth or 8
_G.KillAuraDelay = _G.KillAuraDelay or 0.1
_G.AutoClickerEnabled = _G.AutoClickerEnabled or false
_G.FlyEnabled = _G.FlyEnabled or false
_G.SpeedEnabled = _G.SpeedEnabled or false
_G.SpiderEnabled = _G.SpiderEnabled or false
_G.ESPEnabled = _G.ESPEnabled or false
_G.FullbrightEnabled = _G.FullbrightEnabled or false
_G.ChamsEnabled = _G.ChamsEnabled or false
_G.AutoBuyEnabled = _G.AutoBuyEnabled or false
_G.AutoBuyRange = _G.AutoBuyRange or 15
_G.AntiVoidEnabled = _G.AntiVoidEnabled or false
_G.AutoLeaveEnabled = _G.AutoLeaveEnabled or false
_G.OwnedStoneSword = _G.OwnedStoneSword or false
_G.OwnedLeatherHelmet = _G.OwnedLeatherHelmet or false
_G.OwnedLeatherChestplate = _G.OwnedLeatherChestplate or false
_G.OwnedLeatherBoots = _G.OwnedLeatherBoots or false

-- Network Pfade
local SwordHit, SwordSwingMiss, BedwarsPurchaseItem

pcall(function()
    local NetManaged = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged")
    SwordHit = NetManaged:WaitForChild("SwordHit")
    SwordSwingMiss = NetManaged:WaitForChild("SwordSwingMiss")
    BedwarsPurchaseItem = NetManaged:WaitForChild("BedwarsPurchaseItem")
end)

-- Weapon finden
local function GetCurrentWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("sword")) then
                return item
            end
        end
    end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("sword")) then
            return item
        end
    end
    return nil
end

-- Kill Aura
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

-- AutoClicker
task.spawn(function()
    while true do
        task.wait(1/15)
        if _G.AutoClickerEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            pcall(fireclickdetector)
        end
    end
end)

-- Fly
local FlyBV = nil
local FlyConnection = nil

local function StopFly()
    if FlyBV then FlyBV:Destroy(); FlyBV = nil end
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.FlyEnabled and LocalPlayer.Character then
            if not FlyBV then
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
                    if FlyBV then FlyBV.Velocity = move * 50 end
                end)
            end
        elseif not _G.FlyEnabled then
            StopFly()
        end
    end
end)

-- Speed
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

-- Spider
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

-- ESP
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

-- Fullbright
task.spawn(function()
    local origAmbient = Lighting.Ambient
    local origBrightness = Lighting.Brightness
    while true do
        task.wait(0.3)
        if _G.FullbrightEnabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = origAmbient
            Lighting.Brightness = origBrightness
        end
    end
end)

-- Chams
local ChamsHighlights = {}
task.spawn(function()
    while true do
        for _, h in pairs(ChamsHighlights) do pcall(function() h:Destroy() end) end
        ChamsHighlights = {}
        
        if _G.ChamsEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
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

-- AutoBuy
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

-- AntiVoid
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

-- Auto Leave
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

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        if _G.OnionFallback and _G.OnionFrame then
            _G.OnionFrame.Visible = not _G.OnionFrame.Visible
        elseif Onion then
            Onion:ToggleUI()
        end
    elseif input.KeyCode == Enum.KeyCode.F6 then
        _G.KillAuraEnabled = not _G.KillAuraEnabled
    elseif input.KeyCode == Enum.KeyCode.F7 then
        _G.AutoBuyEnabled = not _G.AutoBuyEnabled
        if _G.AutoBuyEnabled then
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
        end
    elseif input.KeyCode == Enum.KeyCode.F8 then
        _G.FlyEnabled = not _G.FlyEnabled
    elseif input.KeyCode == Enum.KeyCode.F9 then
        _G.SpeedEnabled = not _G.SpeedEnabled
    elseif input.KeyCode == Enum.KeyCode.F10 then
        _G.ESPEnabled = not _G.ESPEnabled
    elseif input.KeyCode == Enum.KeyCode.F11 then
        _G.FullbrightEnabled = not _G.FullbrightEnabled
    end
end)

print("Bedwars Script geladen! Drücke F5 für UI")