--[[
    Rayfield Ultra Script - ESP, Speed, Fly, Fling
    Kompatibel mit: Krnl, Synapse, ScriptWare, Valyse, Fluxus, Electron
    Toggle UI mit der Taste [K]
--]]

-- Rayfield Library laden
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== VARIABLEN =====
local speed = 100
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local flingActive = false
local espEnabled = true
local espObjects = {}
local moveDirection = Vector3.new()

-- ===== ESP SYSTEM =====
local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Adornee = player.Character.HumanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 250
    billboard.Parent = player.Character.HumanoidRootPart
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.new(0, 1, 0)
    healthLabel.TextStrokeTransparency = 0.3
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = billboard
    
    espObjects[player] = {billboard, nameLabel, healthLabel}
    
    local function updateESP()
        if not espEnabled or not billboard.Parent then return end
        
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart and Camera then
            local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
            nameLabel.Text = player.Name .. "  [" .. math.floor(distance) .. "m]"
        else
            nameLabel.Text = player.Name
        end
        
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            local health = humanoid.Health
            local maxHealth = humanoid.MaxHealth
            local healthPercent = health / maxHealth
            healthLabel.Text = "❤️ " .. math.floor(health) .. "/" .. maxHealth
            healthLabel.TextColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
        else
            healthLabel.Text = "❤️ Dead"
        end
    end
    
    local conn = RunService.RenderStepped:Connect(updateESP)
    espObjects[player][4] = conn
end

local function removeESP(player)
    if espObjects[player] then
        local billboard = espObjects[player][1]
        local conn = espObjects[player][4]
        if conn then conn:Disconnect() end
        if billboard then billboard:Destroy() end
        espObjects[player] = nil
    end
end

local function refreshESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if espEnabled then
                if not espObjects[player] then
                    createESP(player)
                end
            else
                removeESP(player)
            end
        end
    end
end

-- ===== SPEED SYSTEM =====
local function setSpeed(newSpeed)
    speed = math.clamp(newSpeed, 1, 500)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- ===== FLY SYSTEM =====
local function startFly()
    if flying then return end
    flying = true
    
    local char = LocalPlayer.Character
    if not char then flying = false return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then flying = false return end
    
    -- PlatformStand aktivieren für bessere Flugkontrolle
    humanoid.PlatformStand = true
    
    -- BodyVelocity für Bewegung
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
    bodyVelocity.Parent = rootPart
    
    -- BodyGyro für Orientierung
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
    bodyGyro.Parent = rootPart
    bodyGyro.CFrame = rootPart.CFrame
    
    moveDirection = Vector3.new()
    
    -- Input Handling
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if not flying then return end
        if input.KeyCode == Enum.KeyCode.W then moveDirection = moveDirection + Vector3.new(0, 0, -1) end
        if input.KeyCode == Enum.KeyCode.S then moveDirection = moveDirection + Vector3.new(0, 0, 1) end
        if input.KeyCode == Enum.KeyCode.A then moveDirection = moveDirection + Vector3.new(-1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveDirection = moveDirection + Vector3.new(1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDirection = moveDirection + Vector3.new(0, -1, 0) end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gpe)
        if not flying then return end
        if input.KeyCode == Enum.KeyCode.W then moveDirection = moveDirection - Vector3.new(0, 0, -1) end
        if input.KeyCode == Enum.KeyCode.S then moveDirection = moveDirection - Vector3.new(0, 0, 1) end
        if input.KeyCode == Enum.KeyCode.A then moveDirection = moveDirection - Vector3.new(-1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveDirection = moveDirection - Vector3.new(1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDirection = moveDirection - Vector3.new(0, -1, 0) end
    end)
    
    -- Bewegung pro Frame
    RunService.RenderStepped:Connect(function()
        if not flying or not bodyVelocity then return end
        local camCFrame = Camera.CFrame
        local velocity = (camCFrame.LookVector * moveDirection.Z + 
                         camCFrame.RightVector * moveDirection.X + 
                         camCFrame.UpVector * moveDirection.Y) * flySpeed
        bodyVelocity.Velocity = velocity
        if bodyGyro then bodyGyro.CFrame = camCFrame end
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

-- ===== FLING SYSTEM =====
local function fling()
    if flingActive then return end
    flingActive = true
    
    local char = LocalPlayer.Character
    if not char then flingActive = false return end
    
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then flingActive = false return end
    
    -- Explosions-Impuls
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 1000000
    bv.Velocity = Vector3.new(0, 250, 0)
    bv.Parent = rootPart
    
    task.wait(0.15)
    bv:Destroy()
    
    -- Zusätzlicher Schub nach oben
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1, 1, 1) * 1000000
    bp.Position = rootPart.Position + Vector3.new(0, 80, 0)
    bp.Parent = rootPart
    
    task.wait(0.25)
    bp:Destroy()
    flingActive = false
end

-- ===== GUI ERSTELLEN =====
local Window = Rayfield:CreateWindow({
    Name = "Ultra Script",
    LoadingTitle = "Rayfield Ultra",
    LoadingSubtitle = "by Developer",
    ToggleUIKeybind = "K",  -- <-- DRÜCKE K ZUM ÖFFNEN!
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UltraScript",
        FileName = "Settings"
    }
})

-- Tabs
local MainTab = Window:CreateTab("Main")
local VisualsTab = Window:CreateTab("Visuals")
local MovementTab = Window:CreateTab("Movement")

-- Main Tab
MainTab:CreateButton({
    Name = "💥 FLING (Explosionssprung)",
    Callback = function()
        fling()
        Rayfield:Notify({Title = "Fling", Content = "Du wurdest geflingt!", Duration = 2})
    end,
})

MainTab:CreateButton({
    Name = "🔄 ESP Neuladen",
    Callback = function()
        refreshESP()
        Rayfield:Notify({Title = "ESP", Content = "ESP wurde aktualisiert", Duration = 2})
    end,
})

-- Visuals Tab
VisualsTab:CreateToggle({
    Name = "👁️ ESP aktivieren",
    CurrentValue = espEnabled,
    Flag = "ESPToggle",
    Callback = function(value)
        espEnabled = value
        if espEnabled then
            refreshESP()
        else
            for player, _ in pairs(espObjects) do
                removeESP(player)
            end
        end
    end
})

-- Movement Tab
MovementTab:CreateSlider({
    Name = "⚡ Speed (1-500 | Standard 100)",
    Range = {1, 500},
    Increment = 1,
    Suffix = "Studs/s",
    CurrentValue = 100,
    Flag = "SpeedSlider",
    Callback = function(value)
        setSpeed(value)
        Rayfield:Notify({Title = "Speed", Content = "Neue Geschwindigkeit: " .. value, Duration = 1})
    end
})

MovementTab:CreateToggle({
    Name = "🕊️ Fly Modus",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        if value then
            startFly()
            Rayfield:Notify({Title = "Fly", Content = "Flugmodus AKTIVIERT (WASD + Leertaste/Strg)", Duration = 3})
        else
            stopFly()
            Rayfield:Notify({Title = "Fly", Content = "Flugmodus DEAKTIVIERT", Duration = 2})
        end
    end
})

MovementTab:CreateSlider({
    Name = "✈️ Fly-Geschwindigkeit",
    Range = {20, 200},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(value)
        flySpeed = value
    end
})

-- ===== EVENT HANDLER =====
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setSpeed(speed)
    if flying then
        stopFly()
        task.wait(0.1)
        startFly()
    end
end)

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer and espEnabled then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if espEnabled then createESP(player) end
        end)
        task.wait(0.5)
        if player.Character then createESP(player) end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- ===== START =====
task.wait(1)
refreshESP()
setSpeed(100)

Rayfield:Notify({
    Title = "✅ Script geladen!",
    Content = "Drücke [K] um das Menu zu öffnen!",
    Duration = 5
})