-- Bedwars Complete Script mit Rayfield UI
-- Alle Features: Kill Aura, AutoBuy, Fly, Speed, ESP, Fullbright, Spider, AutoClicker, AntiVoid, Auto Leave, Config

-- ========== FEHLERBEHANDLUNG + RAYFIELD LADEN ==========
local Success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)

if not Success or not Rayfield then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fehler",
        Text = "Rayfield konnte nicht geladen werden. Script wird trotzdem ausgeführt (Hotkeys: F6 Kill Aura, F7 AutoBuy, F8 Fly)",
        Duration = 5
    })
else
    -- Normales Rayfield UI
    local Window = Rayfield:CreateWindow({
        Name = "Bedwars X Rayfield",
        Icon = 0,
        LoadingTitle = "Bedwars Script",
        LoadingSubtitle = "Alle Features geladen",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "BedwarsScript",
            FileName = "Config"
        },
        Discord = { Enabled = false },
        KeySystem = false
    })
    
    -- Tabs erstellen
    local CombatTab = Window:CreateTab("⚔️ Combat", 4484622459)
    local MovementTab = Window:CreateTab("🏃 Movement", 4484622459)
    local RenderTab = Window:CreateTab("🎨 Render", 4484622459)
    local UtilityTab = Window:CreateTab("🛠️ Utility", 4484622459)
    local AutoBuyTab = Window:CreateTab("🛒 AutoBuy", 4484622459)
    local ConfigTab = Window:CreateTab("💾 Config", 4484622459)
end

-- ========== HAUPTVARIABLEN ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

-- ========== NETWORK PFADE ==========
local NetManaged, SwordHit, SwordSwingMiss, BedwarsPurchaseItem, SetInvItem, SetArmorInvItem

pcall(function()
    NetManaged = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged")
    SwordHit = NetManaged:WaitForChild("SwordHit")
    SwordSwingMiss = NetManaged:WaitForChild("SwordSwingMiss")
    BedwarsPurchaseItem = NetManaged:WaitForChild("BedwarsPurchaseItem")
    SetInvItem = NetManaged:WaitForChild("SetInvItem")
    SetArmorInvItem = NetManaged:WaitForChild("SetArmorInvItem")
end)

-- ========== INVENTAR FINDEN ==========
local PlayerInventory = nil
local CachedInvItems = nil
local Weapon = nil

pcall(function()
    local InventoryFolder = ReplicatedStorage:WaitForChild("Inventories")
    for _, child in pairs(InventoryFolder:GetChildren()) do
        if child:FindFirstChild("stone_sword") or child:FindFirstChild("wood_sword") then
            PlayerInventory = child
            break
        end
    end
    if not PlayerInventory then
        PlayerInventory = InventoryFolder:GetChildren()[1]
    end
    
    Weapon = PlayerInventory and (PlayerInventory:FindFirstChild("stone_sword") or PlayerInventory:FindFirstChild("wood_sword") or PlayerInventory:GetChildren()[1]) or nil
    
    CachedInvItems = ReplicatedStorage:WaitForChild("CachedInvItems")
end)

-- ========== KILL AURA ==========
_G.KillAuraEnabled = false
_G.KillAuraRadius = 20
_G.KillAuraDepth = 8
_G.KillAuraDelay = 0.1

local function GetClosestEnemy()
    if not LocalPlayer.Character then return nil end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local shortestDist = _G.KillAuraRadius
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
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
    return closest
end

task.spawn(function()
    while true do
        task.wait(_G.KillAuraDelay)
        if _G.KillAuraEnabled and LocalPlayer.Character and Weapon then
            local target = GetClosestEnemy()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local args = {{
                        chargedAttack = { chargeRatio = 0 },
                        entityInstance = target.Character,
                        validate = {
                            selfPosition = { value = LocalPlayer.Character.HumanoidRootPart.Position },
                            targetPosition = { value = target.Character.HumanoidRootPart.Position }
                        },
                        weapon = Weapon
                    }}
                    if SwordHit then SwordHit:FireServer(unpack(args)) end
                end)
            elseif SwordSwingMiss then
                pcall(function()
                    local args = {{ weapon = Weapon, chargeRatio = 0 }}
                    SwordSwingMiss:FireServer(unpack(args))
                end)
            end
        end
    end
end)

-- ========== AUTO CLICKER ==========
_G.AutoClickerEnabled = false

task.spawn(function()
    while true do
        task.wait(1/15)
        if _G.AutoClickerEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            pcall(fireclickdetector)
        end
    end
end)

-- ========== FLY ==========
_G.FlyEnabled = false
local FlyBV = nil

task.spawn(function()
    while true do
        task.wait()
        if _G.FlyEnabled and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
                if not FlyBV or not FlyBV.Parent then
                    FlyBV = Instance.new("BodyVelocity")
                    FlyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    FlyBV.Parent = char
                end
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(1, 0, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Vector3.new(1, 0, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(0, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Vector3.new(0, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
                FlyBV.Velocity = move * 50
            end
        elseif not _G.FlyEnabled and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            if FlyBV then
                FlyBV:Destroy()
                FlyBV = nil
            end
        end
    end
end)

-- ========== SPEED ==========
_G.SpeedEnabled = false

task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
        elseif not _G.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed == 50 then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
end)

-- ========== SPIDER (WALL CLIMB) ==========
_G.SpiderEnabled = false

task.spawn(function()
    while true do
        task.wait()
        if _G.SpiderEnabled and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
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
_G.ESPEnabled = false
local ESPObjects = {}

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.ESPEnabled then
            for _, obj in pairs(ESPObjects) do
                pcall(function() obj:Destroy() end)
            end
            ESPObjects = {}
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and Workspace.CurrentCamera and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            
                            local text = Drawing.new("Text")
                            text.Text = player.Name .. " | " .. math.floor(dist) .. "s"
                            text.Color = Color3.new(1, 1, 1)
                            text.Size = 20
                            text.Center = true
                            text.Position = Vector2.new(pos.X, pos.Y - 30)
                            text.Visible = true
                            table.insert(ESPObjects, text)
                            
                            local box = Drawing.new("Square")
                            box.Color = Color3.new(1, 0, 0)
                            box.Thickness = 2
                            box.Filled = false
                            box.Size = Vector2.new(60, 60)
                            box.Position = Vector2.new(pos.X - 30, pos.Y - 30)
                            box.Visible = true
                            table.insert(ESPObjects, box)
                        end
                    end
                end
            end
        else
            for _, obj in pairs(ESPObjects) do
                pcall(function() obj:Destroy() end)
            end
            ESPObjects = {}
        end
    end
end)

-- ========== FULLBRIGHT ==========
_G.FullbrightEnabled = false

task.spawn(function()
    while true do
        task.wait(0.5)
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

-- ========== CHAMS (GLOW) ==========
_G.ChamsEnabled = false
local ChamsHighlights = {}

task.spawn(function()
    while true do
        task.wait(0.5)
        for _, h in pairs(ChamsHighlights) do
            pcall(function() h:Destroy() end)
        end
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
    end
end)

-- ========== AUTOBUY ==========
_G.AutoBuyEnabled = false
_G.AutoBuyRange = 15
_G.OwnedStoneSword = false
_G.OwnedLeatherHelmet = false
_G.OwnedLeatherChestplate = false
_G.OwnedLeatherBoots = false

local function GetPlayerResources()
    local resources = { iron = 0, gold = 0, diamond = 0, emerald = 0 }
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if name:find("iron") then
                    resources.iron = resources.iron + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
                elseif name:find("gold") then
                    resources.gold = resources.gold + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
                elseif name:find("diamond") then
                    resources.diamond = resources.diamond + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
                elseif name:find("emerald") then
                    resources.emerald = resources.emerald + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
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
        if obj.Name:find("Shop") or obj.Name:find("ItemShop") or obj.Name:find("ShopStand") then
            local shopPos = obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or obj.Position
            if shopPos and (hrp.Position - shopPos).Magnitude <= _G.AutoBuyRange then
                return true
            end
        end
    end
    return false
end

local function BuyStoneSword()
    if not _G.OwnedStoneSword and GetPlayerResources().iron >= 20 and IsNearShop() and BedwarsPurchaseItem and SetInvItem then
        pcall(function()
            local args = {{
                shopItem = {
                    lockAfterPurchase = true,
                    itemType = "stone_sword",
                    price = 20,
                    requireInInventoryToTierUp = true,
                    nextTier = "iron_sword",
                    superiorItems = { "iron_sword" },
                    currency = "iron",
                    ignoreAttribute = "DisableSword",
                    amount = 1,
                    category = "Combat",
                    disabledInQueue = { "tnt_wars" },
                    spawnWithItems = { "stone_sword" },
                    ignoredByKit = { "barbarian", "dasher", "frost_hammer_kit", "tinker", "summoner", "void_knight", "gun_blade" }
                },
                shopId = "1_item_shop"
            }}
            BedwarsPurchaseItem:InvokeServer(unpack(args))
            task.wait(0.2)
            local setArgs = {{ hand = CachedInvItems:WaitForChild("stone_sword") }}
            SetInvItem:InvokeServer(unpack(setArgs))
            _G.OwnedStoneSword = true
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "AutoBuy", Text = "Steinschwert gekauft!", Duration = 2 })
        end)
    end
end

local function BuyLeatherArmor()
    local resources = GetPlayerResources()
    
    if not _G.OwnedLeatherHelmet and resources.iron >= 50 and IsNearShop() and BedwarsPurchaseItem and SetArmorInvItem then
        pcall(function()
            local args = {{
                shopItem = {
                    lockAfterPurchase = true,
                    itemType = "leather_helmet",
                    price = 50,
                    customDisplayName = "Leather Armor",
                    superiorItems = { "iron_helmet" },
                    currency = "iron",
                    amount = 1,
                    category = "Combat",
                    ignoredByKit = { "bigman", "tinker", "void_knight" },
                    spawnWithItems = { "leather_helmet", "leather_chestplate", "leather_boots" },
                    nextTier = "iron_helmet"
                },
                shopId = "1_item_shop"
            }}
            BedwarsPurchaseItem:InvokeServer(unpack(args))
            task.wait(0.2)
            local setArgs = {{ item = CachedInvItems:WaitForChild("leather_helmet"), armorSlot = 0 }}
            SetArmorInvItem:InvokeServer(unpack(setArgs))
            _G.OwnedLeatherHelmet = true
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "AutoBuy", Text = "Lederhelm gekauft!", Duration = 2 })
        end)
    end
    
    if not _G.OwnedLeatherChestplate and resources.iron >= 50 and IsNearShop() and BedwarsPurchaseItem and SetArmorInvItem then
        pcall(function()
            local args = {{
                shopItem = {
                    lockAfterPurchase = true,
                    itemType = "leather_chestplate",
                    price = 50,
                    customDisplayName = "Leather Armor",
                    superiorItems = { "iron_chestplate" },
                    currency = "iron",
                    amount = 1,
                    category = "Combat",
                    ignoredByKit = { "bigman", "tinker", "void_knight" },
                    spawnWithItems = { "leather_helmet", "leather_chestplate", "leather_boots" },
                    nextTier = "iron_chestplate"
                },
                shopId = "1_item_shop"
            }}
            BedwarsPurchaseItem:InvokeServer(unpack(args))
            task.wait(0.2)
            local setArgs = {{ item = CachedInvItems:WaitForChild("leather_chestplate"), armorSlot = 1 }}
            SetArmorInvItem:InvokeServer(unpack(setArgs))
            _G.OwnedLeatherChestplate = true
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "AutoBuy", Text = "Lederbrustplatte gekauft!", Duration = 2 })
        end)
    end
    
    if not _G.OwnedLeatherBoots and resources.iron >= 50 and IsNearShop() and BedwarsPurchaseItem and SetArmorInvItem then
        pcall(function()
            local args = {{
                shopItem = {
                    lockAfterPurchase = true,
                    itemType = "leather_boots",
                    price = 50,
                    customDisplayName = "Leather Armor",
                    superiorItems = { "iron_boots" },
                    currency = "iron",
                    amount = 1,
                    category = "Combat",
                    ignoredByKit = { "bigman", "tinker", "void_knight" },
                    spawnWithItems = { "leather_helmet", "leather_chestplate", "leather_boots" },
                    nextTier = "iron_boots"
                },
                shopId = "1_item_shop"
            }}
            BedwarsPurchaseItem:InvokeServer(unpack(args))
            task.wait(0.2)
            local setArgs = {{ item = CachedInvItems:WaitForChild("leather_boots"), armorSlot = 2 }}
            SetArmorInvItem:InvokeServer(unpack(setArgs))
            _G.OwnedLeatherBoots = true
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "AutoBuy", Text = "Lederstiefel gekauft!", Duration = 2 })
        end)
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoBuyEnabled then
            BuyStoneSword()
            BuyLeatherArmor()
        end
    end
end)

-- ========== ANTIVOID ==========
_G.AntiVoidEnabled = false

task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AntiVoidEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character.HumanoidRootPart.Position.Y < 0 then
                LocalPlayer.Character.Humanoid.Health = 0
            end
        end
    end
end)

-- ========== AUTO LEAVE ==========
_G.AutoLeaveEnabled = false

if LocalPlayer.Character then
    LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
        if _G.AutoLeaveEnabled then
            task.wait(1)
            TeleportService:Teleport(game.PlaceId)
        end
    end)
end

-- ========== UI ELEMENTE (wenn Rayfield geladen) ==========
if Rayfield then
    -- Combat Tab
    CombatTab:CreateToggle({
        Name = "⚔️ Kill Aura (20 Studs, 8 Tiefe)",
        CurrentValue = false,
        Flag = "KillAura",
        Callback = function(Value) _G.KillAuraEnabled = Value end
    })
    
    CombatTab:CreateSlider({
        Name = "Kill Aura Radius",
        Range = {5, 30}, Increment = 1, Suffix = "Studs",
        CurrentValue = 20, Flag = "KillAuraRadius",
        Callback = function(Value) _G.KillAuraRadius = Value end
    })
    
    CombatTab:CreateSlider({
        Name = "Kill Aura Tiefe (Y-Achse)",
        Range = {2, 15}, Increment = 1, Suffix = "Studs",
        CurrentValue = 8, Flag = "KillAuraDepth",
        Callback = function(Value) _G.KillAuraDepth = Value end
    })
    
    CombatTab:CreateSlider({
        Name = "Kill Aura Verzögerung",
        Range = {0.05, 0.5}, Increment = 0.05, Suffix = "s",
        CurrentValue = 0.1, Flag = "KillAuraDelay",
        Callback = function(Value) _G.KillAuraDelay = Value end
    })
    
    CombatTab:CreateToggle({
        Name = "🖱️ AutoClicker (15 CPS)",
        CurrentValue = false,
        Flag = "AutoClicker",
        Callback = function(Value) _G.AutoClickerEnabled = Value end
    })
    
    -- Movement Tab
    MovementTab:CreateToggle({
        Name = "🕊️ Fly (NCP Bypass)",
        CurrentValue = false,
        Flag = "Fly",
        Callback = function(Value) _G.FlyEnabled = Value end
    })
    
    MovementTab:CreateToggle({
        Name = "💨 Speed (50 Walkspeed)",
        CurrentValue = false,
        Flag = "Speed",
        Callback = function(Value) _G.SpeedEnabled = Value end
    })
    
    MovementTab:CreateToggle({
        Name = "🕷️ Spider (Wall Climb)",
        CurrentValue = false,
        Flag = "Spider",
        Callback = function(Value) _G.SpiderEnabled = Value end
    })
    
    -- Render Tab
    RenderTab:CreateToggle({
        Name = "👁️ ESP (Nametags + Box)",
        CurrentValue = false,
        Flag = "ESP",
        Callback = function(Value) _G.ESPEnabled = Value end
    })
    
    RenderTab:CreateToggle({
        Name = "💡 Fullbright",
        CurrentValue = false,
        Flag = "Fullbright",
        Callback = function(Value) _G.FullbrightEnabled = Value end
    })
    
    RenderTab:CreateToggle({
        Name = "✨ Chams (Player Glow)",
        CurrentValue = false,
        Flag = "Chams",
        Callback = function(Value) _G.ChamsEnabled = Value end
    })
    
    -- AutoBuy Tab
    AutoBuyTab:CreateToggle({
        Name = "🛒 AutoBuy aktivieren",
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
    
    AutoBuyTab:CreateSlider({
        Name = "AutoBuy Shop-Reichweite",
        Range = {5, 30}, Increment = 1, Suffix = "Studs",
        CurrentValue = 15, Flag = "AutoBuyRange",
        Callback = function(Value) _G.AutoBuyRange = Value end
    })
    
    AutoBuyTab:CreateButton({
        Name = "🔄 Reset Gekauft-Status",
        Callback = function()
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
            Rayfield:Notify({ Title = "AutoBuy", Content = "Status zurückgesetzt", Duration = 2 })
        end
    })
    
    -- Utility Tab
    UtilityTab:CreateToggle({
        Name = "🛡️ AntiVoid (Reset bei Y<0)",
        CurrentValue = false,
        Flag = "AntiVoid",
        Callback = function(Value) _G.AntiVoidEnabled = Value end
    })
    
    UtilityTab:CreateToggle({
        Name = "🚪 Auto Leave (bei Tod)",
        CurrentValue = false,
        Flag = "AutoLeave",
        Callback = function(Value) _G.AutoLeaveEnabled = Value end
    })
    
    -- Config Tab
    ConfigTab:CreateButton({
        Name = "💾 Config Speichern",
        Callback = function()
            Rayfield:SaveConfiguration()
            Rayfield:Notify({ Title = "Config", Content = "Gespeichert!", Duration = 2 })
        end
    })
    
    ConfigTab:CreateButton({
        Name = "📂 Config Laden",
        Callback = function()
            Rayfield:LoadConfiguration()
            Rayfield:Notify({ Title = "Config", Content = "Geladen!", Duration = 2 })
        end
    })
    
    Rayfield:Notify({
        Title = "Bedwars Script",
        Content = "Alle Features geladen!",
        Duration = 3
    })
end

-- ========== HOTKEYS (funktionieren immer) ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F6 then
        _G.KillAuraEnabled = not _G.KillAuraEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Kill Aura",
            Text = _G.KillAuraEnabled and "🟢 AN" or "🔴 AUS",
            Duration = 1
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
            Title = "AutoBuy",
            Text = _G.AutoBuyEnabled and "🟢 AN" or "🔴 AUS",
            Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F8 then
        _G.FlyEnabled = not _G.FlyEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fly",
            Text = _G.FlyEnabled and "🟢 AN" or "🔴 AUS",
            Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F9 then
        _G.SpeedEnabled = not _G.SpeedEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Speed",
            Text = _G.SpeedEnabled and "🟢 AN" or "🔴 AUS",
            Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F10 then
        _G.ESPEnabled = not _G.ESPEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ESP",
            Text = _G.ESPEnabled and "🟢 AN" or "🔴 AUS",
            Duration = 1
        })
    elseif input.KeyCode == Enum.KeyCode.F11 then
        _G.FullbrightEnabled = not _G.FullbrightEnabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fullbright",
            Text = _G.FullbrightEnabled and "🟢 AN" or "🔴 AUS",
            Duration = 1
        })
    end
end)

print("Bedwars Script geladen! Nutze F6-F11 für Toggles")