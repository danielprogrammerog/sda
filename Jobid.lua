-- Bedwars Auto-Kill Aura + AutoBuy + Utility (Rayfield UI)
-- Ohne Key-System | Config Save/Load

-- Rayfield UI laden
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

-- Fenster erstellen
local Window = Rayfield:CreateWindow({
    Name = "Bedwars X Rayfield",
    Icon = 0,
    LoadingTitle = "Bedwars Script",
    LoadingSubtitle = "Auto-Kill Aura + AutoBuy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BedwarsScript",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Tabs
local CombatTab = Window:CreateTab("⚔️ Combat", 4484622459)
local MovementTab = Window:CreateTab("🏃 Movement", 4484622459)
local RenderTab = Window:CreateTab("🎨 Render", 4484622459)
local UtilityTab = Window:CreateTab("🛠️ Utility", 4484622459)
local AutoBuyTab = Window:CreateTab("🛒 AutoBuy", 4484622459)
local ConfigTab = Window:CreateTab("💾 Config", 4484622459)

-- Variablen
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- NetManager Pfade
local NetManaged = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged")
local SwordHit = NetManaged:WaitForChild("SwordHit")
local SwordSwingMiss = NetManaged:WaitForChild("SwordSwingMiss")
local BedwarsPurchaseItem = NetManaged:WaitForChild("BedwarsPurchaseItem")
local SetInvItem = NetManaged:WaitForChild("SetInvItem")
local SetArmorInvItem = NetManaged:WaitForChild("SetArmorInvItem")

-- Inventar-Pfad
local InventoryFolder = ReplicatedStorage:WaitForChild("Inventories")
local PlayerInventory = nil
for _, child in pairs(InventoryFolder:GetChildren()) do
    if child:FindFirstChild("wood_sword") or child:FindFirstChild("stone_sword") then
        PlayerInventory = child
        break
    end
end
if not PlayerInventory then
    PlayerInventory = InventoryFolder:GetChildren()[1]
end

local Weapon = PlayerInventory:FindFirstChild("stone_sword") or PlayerInventory:FindFirstChild("wood_sword") or PlayerInventory:GetChildren()[1]

-- CachedInvItems für Rüstung
local CachedInvItems = ReplicatedStorage:WaitForChild("CachedInvItems")

-- ========== KILL AURA ==========
_G.KillAuraEnabled = false
_G.KillAuraRadius = 20
_G.KillAuraDepth = 8
_G.KillAuraDelay = 0.1

local function GetClosestEnemy()
    local closest = nil
    local shortestDist = _G.KillAuraRadius
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
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

local function KillAuraLoop()
    while _G.KillAuraEnabled do
        task.wait(_G.KillAuraDelay)
        local target = GetClosestEnemy()
        local char = LocalPlayer.Character
        if target and char and char:FindFirstChild("HumanoidRootPart") then
            local targetHrp = target.Character.HumanoidRootPart
            local selfHrp = char.HumanoidRootPart
            
            local args = {{
                chargedAttack = { chargeRatio = 0 },
                entityInstance = target.Character,
                validate = {
                    selfPosition = { value = selfHrp.Position },
                    targetPosition = { value = targetHrp.Position }
                },
                weapon = Weapon
            }}
            pcall(function() SwordHit:FireServer(unpack(args)) end)
        elseif char and not target then
            local args = {{ weapon = Weapon, chargeRatio = 0 }}
            pcall(function() SwordSwingMiss:FireServer(unpack(args)) end)
        end
    end
end

-- ========== AUTOBUY ==========
_G.AutoBuyEnabled = false
_G.AutoBuyRange = 15 -- Distanz zum Shop
_G.OwnedStoneSword = false
_G.OwnedLeatherHelmet = false
_G.OwnedLeatherChestplate = false
_G.OwnedLeatherBoots = false

-- Resourcen des Spielers (Eisen, Gold, etc.)
local function GetPlayerResources()
    local resources = { iron = 0, gold = 0, diamond = 0, emerald = 0 }
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if name:find("iron") then resources.iron = resources.iron + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
                elseif name:find("gold") then resources.gold = resources.gold + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
                elseif name:find("diamond") then resources.diamond = resources.diamond + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
                elseif name:find("emerald") then resources.emerald = resources.emerald + (item:FindFirstChild("Amount") and item.Amount.Value or 1)
                end
            end
        end
    end
    return resources
end

-- Prüft, ob Spieler in der Nähe eines Shops ist
local function IsNearShop()
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Shop") or obj.Name:find("ShopStand") or obj.Name:find("ItemShop") then
            local shopPos = obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or obj.Position
            if shopPos and (hrp.Position - shopPos).Magnitude <= _G.AutoBuyRange then
                return true
            end
        end
    end
    return false
end

-- Kauft Steinschwert
local function BuyStoneSword()
    local resources = GetPlayerResources()
    if resources.iron >= 20 and not _G.OwnedStoneSword and IsNearShop() then
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
                ignoredByKit = {
                    "barbarian", "dasher", "frost_hammer_kit", "tinker", "summoner", "void_knight", "gun_blade"
                }
            },
            shopId = "1_item_shop"
        }}
        local success = pcall(function() return BedwarsPurchaseItem:InvokeServer(unpack(args)) end)
        if success then
            task.wait(0.2)
            local setArgs = {{ hand = CachedInvItems:WaitForChild("stone_sword") }}
            pcall(function() SetInvItem:InvokeServer(unpack(setArgs)) end)
            _G.OwnedStoneSword = true
            Rayfield:Notify({ Title = "AutoBuy", Content = "Steinschwert gekauft!", Duration = 2 })
        end
    end
end

-- Kauft Leder-Rüstung
local function BuyLeatherArmor()
    local resources = GetPlayerResources()
    
    -- Helm
    if resources.iron >= 50 and not _G.OwnedLeatherHelmet and IsNearShop() then
        local argsHelmet = {{
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
        local success = pcall(function() return BedwarsPurchaseItem:InvokeServer(unpack(argsHelmet)) end)
        if success then
            task.wait(0.2)
            local setArmorArgs = {{ item = CachedInvItems:WaitForChild("leather_helmet"), armorSlot = 0 }}
            pcall(function() SetArmorInvItem:InvokeServer(unpack(setArmorArgs)) end)
            _G.OwnedLeatherHelmet = true
            Rayfield:Notify({ Title = "AutoBuy", Content = "Lederhelm gekauft!", Duration = 2 })
        end
    end
    
    -- Brustplatte
    if resources.iron >= 50 and not _G.OwnedLeatherChestplate and IsNearShop() then
        local argsChest = {{
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
        local success = pcall(function() return BedwarsPurchaseItem:InvokeServer(unpack(argsChest)) end)
        if success then
            task.wait(0.2)
            local setArmorArgs = {{ item = CachedInvItems:WaitForChild("leather_chestplate"), armorSlot = 1 }}
            pcall(function() SetArmorInvItem:InvokeServer(unpack(setArmorArgs)) end)
            _G.OwnedLeatherChestplate = true
            Rayfield:Notify({ Title = "AutoBuy", Content = "Lederbrustplatte gekauft!", Duration = 2 })
        end
    end
    
    -- Stiefel
    if resources.iron >= 50 and not _G.OwnedLeatherBoots and IsNearShop() then
        local argsBoots = {{
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
        local success = pcall(function() return BedwarsPurchaseItem:InvokeServer(unpack(argsBoots)) end)
        if success then
            task.wait(0.2)
            local setArmorArgs = {{ item = CachedInvItems:WaitForChild("leather_boots"), armorSlot = 2 }}
            pcall(function() SetArmorInvItem:InvokeServer(unpack(setArmorArgs)) end)
            _G.OwnedLeatherBoots = true
            Rayfield:Notify({ Title = "AutoBuy", Content = "Lederstiefel gekauft!", Duration = 2 })
        end
    end
end

-- AutoBuy Loop
local function AutoBuyLoop()
    while _G.AutoBuyEnabled do
        task.wait(1) -- Prüft jede Sekunde
        if IsNearShop() then
            BuyStoneSword()
            BuyLeatherArmor()
        end
    end
end

-- ========== UI ==========

-- Combat Tab
CombatTab:CreateToggle({
    Name = "Kill Aura (20 Studs, 8 Tiefe)",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        _G.KillAuraEnabled = Value
        if Value then task.spawn(KillAuraLoop) end
    end
})

CombatTab:CreateSlider({
    Name = "Kill Aura Radius",
    Range = {5, 30}, Increment = 1, Suffix = "Studs",
    CurrentValue = 20, Flag = "Radius",
    Callback = function(Value) _G.KillAuraRadius = Value end
})

CombatTab:CreateSlider({
    Name = "Kill Aura Tiefe (Y-Achse)",
    Range = {2, 15}, Increment = 1, Suffix = "Studs",
    CurrentValue = 8, Flag = "Depth",
    Callback = function(Value) _G.KillAuraDepth = Value end
})

CombatTab:CreateSlider({
    Name = "Angriffsverzögerung",
    Range = {0.05, 1}, Increment = 0.05, Suffix = "s",
    CurrentValue = 0.1, Flag = "Delay",
    Callback = function(Value) _G.KillAuraDelay = Value end
})

CombatTab:CreateToggle({
    Name = "AutoClicker (15 CPS)",
    CurrentValue = false, Flag = "AutoClicker",
    Callback = function(Value)
        _G.AutoClicker = Value
        task.spawn(function()
            while _G.AutoClicker do
                if game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    pcall(fireclickdetector)
                end
                task.wait(1/15)
            end
        end)
    end
})

-- Movement Tab
MovementTab:CreateToggle({
    Name = "Fly (NCP Bypass)",
    CurrentValue = false, Flag = "Fly",
    Callback = function(Value)
        _G.FlyEnabled = Value
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if Value then
            humanoid.PlatformStand = true
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = char
            RunService.RenderStepped:Connect(function()
                if not _G.FlyEnabled then bv:Destroy() return end
                local move = Vector3.new()
                local uis = game:GetService("UserInputService")
                if uis:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(1,0,0) end
                if uis:IsKeyDown(Enum.KeyCode.S) then move = move - Vector3.new(1,0,0) end
                if uis:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(0,0,1) end
                if uis:IsKeyDown(Enum.KeyCode.A) then move = move - Vector3.new(0,0,1) end
                if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
                bv.Velocity = move * 50
            end)
        else
            humanoid.PlatformStand = false
            if char:FindFirstChild("BodyVelocity") then char.BodyVelocity:Destroy() end
        end
    end
})

MovementTab:CreateToggle({
    Name = "Speed (50 Walkspeed)",
    CurrentValue = false, Flag = "Speed",
    Callback = function(Value)
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value and 50 or 16
        end
    end
})

-- Render Tab
RenderTab:CreateToggle({
    Name = "ESP (Nametags + Distanz)",
    CurrentValue = false, Flag = "ESP",
    Callback = function(Value)
        _G.ESP = Value
        task.spawn(function()
            while _G.ESP do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and LocalPlayer.Character then
                            local pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                            if onScreen then
                                local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                local text = Drawing.new("Text")
                                text.Text = player.Name .. " | " .. math.floor(dist) .. "s"
                                text.Color = Color3.new(1,1,1)
                                text.Size = 20
                                text.Position = Vector2.new(pos.X - 50, pos.Y - 30)
                                text.Visible = true
                                task.wait(0.1)
                                text:Destroy()
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    end
})

RenderTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false, Flag = "Fullbright",
    Callback = function(Value)
        game:GetService("Lighting").Ambient = Value and Color3.new(1,1,1) or Color3.new(0,0,0)
    end
})

-- AutoBuy Tab
AutoBuyTab:CreateToggle({
    Name = "🛒 AutoBuy aktivieren",
    CurrentValue = false, Flag = "AutoBuy",
    Callback = function(Value)
        _G.AutoBuyEnabled = Value
        if Value then
            -- Reset owned flags
            _G.OwnedStoneSword = false
            _G.OwnedLeatherHelmet = false
            _G.OwnedLeatherChestplate = false
            _G.OwnedLeatherBoots = false
            task.spawn(AutoBuyLoop)
            Rayfield:Notify({ Title = "AutoBuy", Content = "Aktiviert! Kauft bei Shop in der Nähe", Duration = 3 })
        end
    end
})

AutoBuyTab:CreateSlider({
    Name = "AutoBuy Shop-Reichweite",
    Range = {5, 30}, Increment = 1, Suffix = "Studs",
    CurrentValue = 15, Flag = "ShopRange",
    Callback = function(Value) _G.AutoBuyRange = Value end
})

AutoBuyTab:CreateButton({
    Name = "Reset Gekauft-Status",
    Callback = function()
        _G.OwnedStoneSword = false
        _G.OwnedLeatherHelmet = false
        _G.OwnedLeatherChestplate = false
        _G.OwnedLeatherBoots = false
        Rayfield:Notify({ Title = "AutoBuy", Content = "Status zurückgesetzt", Duration = 2 })
    end
})

-- Utility Tab
UtilityTab:CreateButton({
    Name = "AntiVoid (Reset bei Y<0)",
    Callback = function()
        _G.AntiVoid = true
        RunService.RenderStepped:Connect(function()
            if _G.AntiVoid and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character.HumanoidRootPart.Position.Y < 0 then
                    LocalPlayer.Character.Humanoid.Health = 0
                end
            end
        end)
    end
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

-- Start-Notiz
Rayfield:Notify({
    Title = "Bedwars Script",
    Content = "Geladen! AutoBuy kauft Schwert + Rüstung mit Eisen",
    Duration = 4
})