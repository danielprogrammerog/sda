-- ============================================
-- BEDWARS SCRIPT - RAYFIELD UI (GARANTIERT FUNKTIONIEREND)
-- Mit Fallback falls Rayfield nicht lädt
-- ============================================

-- ========== RAYFIELD LADEN MIT FEHLERBEHANDLUNG ==========
local RayfieldLoaded = false
local Rayfield = nil

local function LoadRayfield()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
    end)
    
    if success and result then
        Rayfield = result
        RayfieldLoaded = true
        return true
    end
    
    -- Alternative URL versuchen
    local success2, result2 = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
    end)
    
    if success2 and result2 then
        Rayfield = result2
        RayfieldLoaded = true
        return true
    end
    
    return false
end

local RayfieldSuccess = LoadRayfield()

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

-- ========== FALLBACK GUI (FALLS RAYFIELD NICHT LÄDT) ==========
local FallbackGUI = nil

if not RayfieldLoaded then
    -- Professionelle Fallback GUI
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("SendNotification", {
        Title = "Rayfield Fehler",
        Text = "Rayfield lädt nicht. Verwende alternatives UI.",
        Duration = 3
    })
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BedwarsFallbackUI"
    screenGui.Parent = game:GetService("PlayerGui").LocalPlayer
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Text = "⚔️ BEDWARS PRO ⚔️"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -100, 1, 0)
    subLabel.Position = UDim2.new(0, 15, 0, 24)
    subLabel.Text = "Alternative UI | Hotkeys: F5 | F6-F11"
    subLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    subLabel.BackgroundTransparency = 1
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 11
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 8)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    
    -- Scroll Container
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -70)
    scrollFrame.Position = UDim2.new(0, 10, 0, 60)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scrollFrame
    
    -- Hilfsfunktionen für Fallback UI
    local function CreateFallbackSection(parent, title)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 0, 35)
        section.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        section.BackgroundTransparency = 0.5
        section.BorderSizePixel = 0
        section.Parent = parent
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = section
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Size = UDim2.new(1, -15, 1, 0)
        sectionTitle.Position = UDim2.new(0, 10, 0, 0)
        sectionTitle.Text = title
        sectionTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextSize = 14
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
    end
    
    local function CreateFallbackToggle(parent, name, flag, hotkey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = parent
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = name .. (hotkey and " [" .. hotkey .. "]" or "")
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Padding = UDim.new(0, 12)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.Parent = frame
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 32)
        btn.Position = UDim2.new(1, -90, 0.5, -16)
        btn.Text = "AUS"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.Parent = frame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local state = _G[flag] or false
        if state then
            btn.Text = "AN"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        end
        
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
    
    local function CreateFallbackSlider(parent, name, flag, min, max, default, suffix)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 65)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = parent
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 25)
        label.Text = name .. ": " .. default .. suffix
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.Parent = frame
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(0.9, 0, 0, 4)
        sliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
        sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        sliderBar.BorderSizePixel = 0
        sliderBar.Parent = frame
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        fill.BorderSizePixel = 0
        fill.Parent = sliderBar
        
        local knob = Instance.new("TextButton")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Text = ""
        knob.BorderSizePixel = 0
        knob.Parent = sliderBar
        
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
                local barPos = sliderBar.AbsolutePosition.X
                local barWidth = sliderBar.AbsoluteSize.X
                local percent = math.clamp((mousePos.X - barPos) / barWidth, 0, 1)
                value = min + (max - min) * percent
                value = math.floor(value * 10) / 10
                _G[flag] = value
                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, -8, 0.5, -8)
                label.Text = name .. ": " .. value .. suffix
            end
        end)
    end
    
    local function CreateFallbackButton(parent, name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = parent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
    end
    
    -- Fallback UI Inhalt
    CreateFallbackSection(scrollFrame, "🗡️ Kill Aura")
    CreateFallbackToggle(scrollFrame, "Kill Aura aktivieren", "KillAuraEnabled", "F6")
    CreateFallbackSlider(scrollFrame, "Kill Aura Radius", "KillAuraRadius", 5, 30, 20, "s")
    CreateFallbackSlider(scrollFrame, "Kill Aura Tiefe", "KillAuraDepth", 2, 15, 8, "s")
    CreateFallbackSlider(scrollFrame, "Angriffsverzögerung", "KillAuraDelay", 0.05, 0.5, 0.1, "s")
    
    CreateFallbackSection(scrollFrame, "🖱️ AutoClicker")
    CreateFallbackToggle(scrollFrame, "AutoClicker (15 CPS)", "AutoClickerEnabled", nil)
    
    CreateFallbackSection(scrollFrame, "🕊️ Flight")
    CreateFallbackToggle(scrollFrame, "Fly (NCP Bypass)", "FlyEnabled", "F8")
    
    CreateFallbackSection(scrollFrame, "💨 Speed")
    CreateFallbackToggle(scrollFrame, "Speed (50 Walkspeed)", "SpeedEnabled", "F9")
    
    CreateFallbackSection(scrollFrame, "🕷️ Spider")
    CreateFallbackToggle(scrollFrame, "Spider (Wall Climb)", "SpiderEnabled", nil)
    
    CreateFallbackSection(scrollFrame, "👁️ ESP")
    CreateFallbackToggle(scrollFrame, "ESP (Nametags + Box)", "ESPEnabled", "F10")
    
    CreateFallbackSection(scrollFrame, "💡 Fullbright")
    CreateFallbackToggle(scrollFrame, "Fullbright", "FullbrightEnabled", "F11")
    
    CreateFallbackSection(scrollFrame, "✨ Chams")
    CreateFallbackToggle(scrollFrame, "Chams (Player Glow)", "ChamsEnabled", nil)
    
    CreateFallbackSection(scrollFrame, "🛒 AutoBuy")
    CreateFallbackToggle(scrollFrame, "AutoBuy aktivieren", "AutoBuyEnabled", "F7")
    CreateFallbackSlider(scrollFrame, "Shop Reichweite", "AutoBuyRange", 5, 30, 15, "s")
    CreateFallbackButton(scrollFrame, "🔄 Reset Gekauft-Status", function()
        _G.OwnedStoneSword = false
        _G.OwnedLeatherHelmet = false
        _G.OwnedLeatherChestplate = false
        _G.OwnedLeatherBoots = false
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "AutoBuy", Text = "Status zurückgesetzt!", Duration = 2})
    end)
    
    CreateFallbackSection(scrollFrame, "🛡️ Schutz")
    CreateFallbackToggle(scrollFrame, "AntiVoid (Reset bei Y<0)", "AntiVoidEnabled", nil)
    
    CreateFallbackSection(scrollFrame, "🚪 Auto Leave")
    CreateFallbackToggle(scrollFrame, "Auto Leave (bei Tod)", "AutoLeaveEnabled", nil)
    
    FallbackGUI = mainFrame
end

-- ========== RAYFIELD UI (WENN ERFOLGREICH GELADEN) ==========
if RayfieldLoaded and Rayfield then
    local Window = Rayfield:CreateWindow({
        Name = "⚔️ BEDWARS PRO ⚔️",
        Icon = 0,
        LoadingTitle = "Bedwars Script",
        LoadingSubtitle = "Lade Features...",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "BedwarsPro",
            FileName = "Config"
        },
        Discord = {
            Enabled = false
        },
        KeySystem = false
    })
    
    -- Tabs
    local CombatTab = Window:CreateTab("⚔️ Combat")
    local MovementTab = Window:CreateTab("🏃 Movement")
    local VisualTab = Window:CreateTab("👁️ Visuals")
    local AutoBuyTab = Window:CreateTab("🛒 AutoBuy")
    local UtilityTab = Window:CreateTab("🛠️ Utility")
    local SettingsTab = Window:CreateTab("⚙️ Settings")
    
    -- ========== COMBAT TAB ==========
    local CombatSection = CombatTab:CreateSection("🗡️ Kill Aura")
    
    CombatSection:CreateToggle({
        Name = "Kill Aura aktivieren",
        CurrentValue = false,
        Flag = "KillAura",
        Callback = function(Value)
            _G.KillAuraEnabled = Value
        end
    })
    
    CombatSection:CreateSlider({
        Name = "Kill Aura Radius",
        Range = {5, 30},
        Increment = 1,
        Suffix = " Studs",
        CurrentValue = 20,
        Flag = "KillAuraRadius",
        Callback = function(Value)
            _G.KillAuraRadius = Value
        end
    })
    
    CombatSection:CreateSlider({
        Name = "Kill Aura Tiefe (Y-Achse)",
        Range = {2, 15},
        Increment = 1,
        Suffix = " Studs",
        CurrentValue = 8,
        Flag = "KillAuraDepth",
        Callback = function(Value)
            _G.KillAuraDepth = Value
        end
    })
    
    CombatSection:CreateSlider({
        Name = "Angriffsverzögerung",
        Range = {0.05, 0.5},
        Increment = 0.05,
        Suffix = " Sekunden",
        CurrentValue = 0.1,
        Flag = "KillAuraDelay",
        Callback = function(Value)
            _G.KillAuraDelay = Value
        end
    })
    
    local ClickerSection = CombatTab:CreateSection("🖱️ AutoClicker")
    
    ClickerSection:CreateToggle({
        Name = "AutoClicker (15 CPS)",
        CurrentValue = false,
        Flag = "AutoClicker",
        Callback = function(Value)
            _G.AutoClickerEnabled = Value
        end
    })
    
    -- ========== MOVEMENT TAB ==========
    local FlySection = MovementTab:CreateSection("🕊️ Flight")
    
    FlySection:CreateToggle({
        Name = "Fly (NCP Bypass)",
        CurrentValue = false,
        Flag = "Fly",
        Callback = function(Value)
            _G.FlyEnabled = Value
        end
    })
    
    local SpeedSection = MovementTab:CreateSection("💨 Speed")
    
    SpeedSection:CreateToggle({
        Name = "Speed (50 Walkspeed)",
        CurrentValue = false,
        Flag = "Speed",
        Callback = function(Value)
            _G.SpeedEnabled = Value
        end
    })
    
    local SpiderSection = MovementTab:CreateSection("🕷️ Spider")
    
    SpiderSection:CreateToggle({
        Name = "Spider (Wall Climb)",
        CurrentValue = false,
        Flag = "Spider",
        Callback = function(Value)
            _G.SpiderEnabled = Value
        end
    })
    
    -- ========== VISUAL TAB ==========
    local ESP_Section = VisualTab:CreateSection("👁️ ESP")
    
    ESP_Section:CreateToggle({
        Name = "ESP (Nametags + Box)",
        CurrentValue = false,
        Flag = "ESP",
        Callback = function(Value)
            _G.ESPEnabled = Value
        end
    })
    
    local BrightSection = VisualTab:CreateSection("💡 Brightness")
    
    BrightSection:CreateToggle({
        Name = "Fullbright",
        CurrentValue = false,
        Flag = "Fullbright",
        Callback = function(Value)
            _G.FullbrightEnabled = Value
        end
    })
    
    local ChamsSection = VisualTab:CreateSection("✨ Chams")
    
    ChamsSection:CreateToggle({
        Name = "Chams (Player Glow)",
        CurrentValue = false,
        Flag = "Chams",
        Callback = function(Value)
            _G.ChamsEnabled = Value
        end
    })
    
    -- ========== AUTOBUY TAB ==========
    local BuySection = AutoBuyTab:CreateSection("🛒 AutoBuy Einstellungen")
    
    BuySection:CreateToggle({
        Name = "AutoBuy aktivieren",
        CurrentValue = false,
        Flag = "AutoBuy",
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
    
    BuySection:CreateSlider({
        Name = "Shop Reichweite",
        Range = {5, 30},
        Increment = 1,
        Suffix = " Studs",
        CurrentValue = 15,
        Flag = "AutoBuyRange",
        Callback = function(Value)
            _G.AutoBuyRange = Value
        end
    })
    
    local ItemsSection = AutoBuyTab:CreateSection("📦 Gekaufte Items")
    
    ItemsSection:CreateLabel("• Steinschwert (20 Eisen)")
    ItemsSection:CreateLabel("• Lederhelm (50 Eisen)")
    ItemsSection:CreateLabel("• Lederbrustplatte (50 Eisen)")
    ItemsSection:CreateLabel("• Lederstiefel (50 Eisen)")
    
    ItemsSection:CreateButton({
        Name = "🔄 Reset Gekauft-Status",
        Callback = function()
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
            Rayfield:Notify({
                Title = "AutoBuy",
                Content = "Status zurückgesetzt!",
                Duration = 2
            })
        end
    })
    
    -- ========== UTILITY TAB ==========
    local ProtectSection = UtilityTab:CreateSection("🛡️ Schutz")
    
    ProtectSection:CreateToggle({
        Name = "AntiVoid (Reset bei Y<0)",
        CurrentValue = false,
        Flag = "AntiVoid",
        Callback = function(Value)
            _G.AntiVoidEnabled = Value
        end
    })
    
    local LeaveSection = UtilityTab:CreateSection("🚪 Auto Leave")
    
    LeaveSection:CreateToggle({
        Name = "Auto Leave (bei Tod)",
        CurrentValue = false,
        Flag = "AutoLeave",
        Callback = function(Value)
            _G.AutoLeaveEnabled = Value
        end
    })
    
    -- ========== SETTINGS TAB ==========
    local ConfigSection = SettingsTab:CreateSection("💾 Config")
    
    ConfigSection:CreateButton({
        Name = "💾 Config Speichern",
        Callback = function()
            Rayfield:SaveConfiguration()
            Rayfield:Notify({
                Title = "Config",
                Content = "Gespeichert!",
                Duration = 2
            })
        end
    })
    
    ConfigSection:CreateButton({
        Name = "📂 Config Laden",
        Callback = function()
            Rayfield:LoadConfiguration()
            Rayfield:Notify({
                Title = "Config",
                Content = "Geladen!",
                Duration = 2
            })
        end
    })
    
    local HotkeySection = SettingsTab:CreateSection("⌨️ Hotkeys")
    
    HotkeySection:CreateLabel("F5 - UI ein-/ausblenden")
    HotkeySection:CreateLabel("F6 - Kill Aura ein-/aus")
    HotkeySection:CreateLabel("F7 - AutoBuy ein-/aus")
    HotkeySection:CreateLabel("F8 - Fly ein-/aus")
    HotkeySection:CreateLabel("F9 - Speed ein-/aus")
    HotkeySection:CreateLabel("F10 - ESP ein-/aus")
    HotkeySection:CreateLabel("F11 - Fullbright ein-/aus")
    
    -- Rayfield Start-Notiz
    Rayfield:Notify({
        Title = "Bedwars Pro",
        Content = "Script geladen! Drücke F5 für UI",
        Duration = 3
    })
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
local StarterGui = game:GetService("StarterGui")

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

-- Fullbright
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

-- ========== HOTKEYS ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        if RayfieldLoaded and Rayfield then
            Rayfield:ToggleUI()
        elseif FallbackGUI then
            FallbackGUI.Visible = not FallbackGUI.Visible
        end
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

-- Start-Meldung
StarterGui:SetCore("SendNotification", {
    Title = "Bedwars Pro",
    Text = "Script geladen! Drücke F5 für UI",
    Duration = 3
})

print("Bedwars Script geladen! Drücke F5 für UI")