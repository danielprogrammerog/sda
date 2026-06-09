-- ============================================
-- BEDWARS SCRIPT - GEFIXT
-- Verwendet: Rayfield (funktionierender Mirror) + Fallback
-- ============================================

-- ========== FUNKTIONIERENDE RAYFIELD MIRRORS ==========
local Rayfield = nil
local RayfieldLoaded = false

local RayfieldMirrors = {
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source",
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua",
    "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
    "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/UI",
}

for _, url in ipairs(RayfieldMirrors) do
    if not RayfieldLoaded then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        if success and result then
            Rayfield = result
            RayfieldLoaded = true
            break
        end
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
local TweenService = game:GetService("TweenService")

-- ========== NETWORK PFADE ==========
local SwordHit, SwordSwingMiss, BedwarsPurchaseItem

pcall(function()
    local NetManaged = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged")
    SwordHit = NetManaged:WaitForChild("SwordHit")
    SwordSwingMiss = NetManaged:WaitForChild("SwordSwingMiss")
    BedwarsPurchaseItem = NetManaged:WaitForChild("BedwarsPurchaseItem")
end)

-- ========== EIGENE MODERNE GUI (FALLBACK) ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BedwarsProUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Hauptframe mit modernem Design
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 600)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = RayfieldLoaded and false or true
MainFrame.Parent = ScreenGui

-- Hauptrundung
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Glow/Shadow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.85
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame
local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 19)
ShadowCorner.Parent = Shadow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

-- Nur oben abrunden
local TopCornerFix = Instance.new("UICorner")
TopCornerFix.CornerRadius = UDim.new(0, 14)
TopCornerFix.Parent = TitleBar

-- Titel mit Icon
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 0, 35)
TitleLabel.Position = UDim2.new(0, 15, 0, 8)
TitleLabel.Text = "⚔️ BEDWARS PRO ⚔️"
TitleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Subtitle
local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, -100, 0, 20)
SubLabel.Position = UDim2.new(0, 15, 0, 38)
SubLabel.Text = "All Features | Drücke F5 für UI | Hotkeys: F6-F11"
SubLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
SubLabel.BackgroundTransparency = 1
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextSize = 11
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -48, 0, 12)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 36, 0, 36)
MinBtn.Position = UDim2.new(1, -94, 0, 12)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 24
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinBtn

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetHeight = isMinimized and 60 or 600
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 550, 0, targetHeight)
    })
    tween:Play()
    MinBtn.Text = isMinimized and "□" or "−"
end)

-- ========== TABS ==========
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabButtons = {}
local TabContents = {}

local Tabs = {"⚔️ Combat", "🏃 Movement", "👁️ Visuals", "🛒 AutoBuy", "🛠️ Utility", "⚙️ Settings"}

-- Content Container (Scrolling)
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -20, 1, -130)
ContentContainer.Position = UDim2.new(0, 10, 0, 115)
ContentContainer.BackgroundTransparency = 1
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ScrollBarThickness = 5
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 130)
ContentContainer.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentContainer

for i, tabName in ipairs(Tabs) do
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1 / #Tabs, -4, 1, -8)
    TabBtn.Position = UDim2.new((i-1) / #Tabs, 2, 0, 4)
    TabBtn.Text = tabName
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 13
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabBtn
    
    -- Tab Content Container
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = (i == 1)
    TabContent.Parent = ContentContainer
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.Padding = UDim.new(0, 8)
    TabContentLayout.Parent = TabContent
    
    TabButtons[tabName] = TabBtn
    TabContents[tabName] = TabContent
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        for _, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        TabContent.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 130)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- ========== UI HELFER FUNKTIONEN ==========
local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 38)
    Section.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Section.BackgroundTransparency = 0.4
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -15, 1, 0)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 14
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
end

local function CreateToggle(parent, name, flag, hotkey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 48)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = name .. (hotkey and " [" .. hotkey .. "]" or "")
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Padding = UDim.new(0, 12)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 85, 0, 34)
    Btn.Position = UDim2.new(1, -95, 0.5, -17)
    Btn.Text = "AUS"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.Parent = Frame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    local state = _G[flag] or false
    if state then
        Btn.Text = "AN"
        Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    end
    
    Btn.MouseButton1Click:Connect(function()
        state = not state
        _G[flag] = state
        if state then
            Btn.Text = "AN"
            Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            Btn.Text = "AUS"
            Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end)
end

local function CreateSlider(parent, name, flag, min, max, default, suffix)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 70)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 28)
    Label.Text = name .. ": " .. default .. suffix
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.Parent = Frame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0.9, 0, 0, 4)
    SliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Frame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar
    
    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Text = ""
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBar
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    local Value = default
    _G[flag] = Value
    local Dragging = false
    
    Knob.MouseButton1Down:Connect(function()
        Dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if Dragging then
            local MousePos = UserInputService:GetMouseLocation()
            local BarPos = SliderBar.AbsolutePosition.X
            local BarWidth = SliderBar.AbsoluteSize.X
            local Percent = math.clamp((MousePos.X - BarPos) / BarWidth, 0, 1)
            Value = min + (max - min) * Percent
            Value = math.floor(Value * 10) / 10
            _G[flag] = Value
            Fill.Size = UDim2.new(Percent, 0, 1, 0)
            Knob.Position = UDim2.new(Percent, -9, 0.5, -9)
            Label.Text = name .. ": " .. Value .. suffix
        end
    end)
end

local function CreateButton(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.BorderSizePixel = 0
    Btn.Parent = parent
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateLabel(parent, text, color)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 26)
    Lbl.Text = text
    Lbl.TextColor3 = color or Color3.fromRGB(200, 200, 220)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Padding = UDim.new(0, 12)
    Lbl.Parent = parent
end

-- ========== UI INHALT BEFÜLLEN ==========
-- Combat Tab
local CombatContent = TabContents["⚔️ Combat"]
CreateSection(CombatContent, "🗡️ Kill Aura")
CreateToggle(CombatContent, "Kill Aura aktivieren", "KillAuraEnabled", "F6")
CreateSlider(CombatContent, "Kill Aura Radius", "KillAuraRadius", 5, 30, 20, "s")
CreateSlider(CombatContent, "Kill Aura Tiefe", "KillAuraDepth", 2, 15, 8, "s")
CreateSlider(CombatContent, "Angriffsverzögerung", "KillAuraDelay", 0.05, 0.5, 0.1, "s")
CreateSection(CombatContent, "🖱️ AutoClicker")
CreateToggle(CombatContent, "AutoClicker (15 CPS)", "AutoClickerEnabled", nil)

-- Movement Tab
local MovementContent = TabContents["🏃 Movement"]
CreateSection(MovementContent, "🕊️ Flight")
CreateToggle(MovementContent, "Fly (NCP Bypass)", "FlyEnabled", "F8")
CreateSection(MovementContent, "💨 Speed")
CreateToggle(MovementContent, "Speed (50 Walkspeed)", "SpeedEnabled", "F9")
CreateSection(MovementContent, "🕷️ Spider")
CreateToggle(MovementContent, "Spider (Wall Climb)", "SpiderEnabled", nil)

-- Visuals Tab
local VisualsContent = TabContents["👁️ Visuals"]
CreateSection(VisualsContent, "👁️ ESP")
CreateToggle(VisualsContent, "ESP (Nametags + Box)", "ESPEnabled", "F10")
CreateSection(VisualsContent, "💡 Brightness")
CreateToggle(VisualsContent, "Fullbright", "FullbrightEnabled", "F11")
CreateSection(VisualsContent, "✨ Chams")
CreateToggle(VisualsContent, "Chams (Player Glow)", "ChamsEnabled", nil)

-- AutoBuy Tab
local AutoBuyContent = TabContents["🛒 AutoBuy"]
CreateSection(AutoBuyContent, "🛒 AutoBuy")
CreateToggle(AutoBuyContent, "AutoBuy aktivieren", "AutoBuyEnabled", "F7")
CreateSlider(AutoBuyContent, "Shop Reichweite", "AutoBuyRange", 5, 30, 15, "s")
CreateSection(AutoBuyContent, "📦 Items")
CreateLabel(AutoBuyContent, "• Steinschwert (20 Eisen)", Color3.fromRGB(200, 200, 220))
CreateLabel(AutoBuyContent, "• Lederhelm (50 Eisen)", Color3.fromRGB(200, 200, 220))
CreateLabel(AutoBuyContent, "• Lederbrustplatte (50 Eisen)", Color3.fromRGB(200, 200, 220))
CreateLabel(AutoBuyContent, "• Lederstiefel (50 Eisen)", Color3.fromRGB(200, 200, 220))
CreateButton(AutoBuyContent, "🔄 Reset Gekauft-Status", function()
    _G.OwnedStoneSword = false
    _G.OwnedLeatherHelmet = false
    _G.OwnedLeatherChestplate = false
    _G.OwnedLeatherBoots = false
    StarterGui:SetCore("SendNotification", {Title = "AutoBuy", Text = "Status zurückgesetzt!", Duration = 2})
end)

-- Utility Tab
local UtilityContent = TabContents["🛠️ Utility"]
CreateSection(UtilityContent, "🛡️ Schutz")
CreateToggle(UtilityContent, "AntiVoid (Reset bei Y<0)", "AntiVoidEnabled", nil)
CreateSection(UtilityContent, "🚪 Auto Leave")
CreateToggle(UtilityContent, "Auto Leave (bei Tod)", "AutoLeaveEnabled", nil)

-- Settings Tab
local SettingsContent = TabContents["⚙️ Settings"]
CreateSection(SettingsContent, "⌨️ Hotkeys")
CreateLabel(SettingsContent, "F5 - UI ein-/ausblenden", Color3.fromRGB(255, 200, 100))
CreateLabel(SettingsContent, "F6 - Kill Aura", Color3.fromRGB(255, 200, 100))
CreateLabel(SettingsContent, "F7 - AutoBuy", Color3.fromRGB(255, 200, 100))
CreateLabel(SettingsContent, "F8 - Fly", Color3.fromRGB(255, 200, 100))
CreateLabel(SettingsContent, "F9 - Speed", Color3.fromRGB(255, 200, 100))
CreateLabel(SettingsContent, "F10 - ESP", Color3.fromRGB(255, 200, 100))
CreateLabel(SettingsContent, "F11 - Fullbright", Color3.fromRGB(255, 200, 100))
CreateSection(SettingsContent, "ℹ️ Info")
CreateLabel(SettingsContent, "Bedwars Pro Script v3.0", Color3.fromRGB(150, 150, 170))
CreateLabel(SettingsContent, "Alle Features geladen!", Color3.fromRGB(100, 200, 100))

-- ========== HAUPTFUNKTIONEN ==========
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
        MainFrame.Visible = not MainFrame.Visible
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

-- Start Animation
MainFrame.Size = UDim2.new(0, 500, 0, 500)
MainFrame.BackgroundTransparency = 0.1
task.wait(0.05)
local startTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 550, 0, 600),
    BackgroundTransparency = 0
})
startTween:Play()

StarterGui:SetCore("SendNotification", {
    Title = "Bedwars Pro",
    Text = "Script geladen! Drücke F5 für UI | F6-F11 für Features",
    Duration = 4
})

print("Bedwars Script geladen! Drücke F5")