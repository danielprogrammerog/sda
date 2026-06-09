-- Secure Mode für bessere Kompatibilität
getgenv().SecureMode = true

-- Alternative Rayfield-Quelle (funktioniert in fast allen Executoren)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variablen
local speed = 100
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bg = nil
local flingActive = false
local espEnabled = true
local espObjects = {}

-- ESP Funktionen (gleich wie vorher)
local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Adornee = player.Character.HumanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 200
    billboard.Parent = player.Character.HumanoidRootPart
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.new(0, 1, 0)
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = billboard
    
    espObjects[player] = {billboard, nameLabel, healthLabel}
    
    local function updateESP()
        if not espEnabled or not billboard.Parent then return end
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart and Camera then
            local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
            nameLabel.Text = player.Name .. " [" .. math.floor(distance) .. "m]"
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
            healthLabel.Text = "❤️ ?"
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

-- Speed Funktion
local function setSpeed(newSpeed)
    speed = math.clamp(newSpeed, 1, 500)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- Fly Funktionen
local function startFly()
    flying = true
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000
    bodyVelocity.Parent = rootPart
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1, 1, 1) * 10000
    bg.Parent = rootPart
    bg.CFrame = rootPart.CFrame
    
    local moveDirection = Vector3.new()
    
    local inputBegan = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then moveDirection = moveDirection + Vector3.new(0, 0, -1) end
        if input.KeyCode == Enum.KeyCode.S then moveDirection = moveDirection + Vector3.new(0, 0, 1) end
        if input.KeyCode == Enum.KeyCode.A then moveDirection = moveDirection + Vector3.new(-1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveDirection = moveDirection + Vector3.new(1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDirection = moveDirection + Vector3.new(0, -1, 0) end
    end)
    
    local inputEnded = UserInputService.InputEnded:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.W then moveDirection = moveDirection - Vector3.new(0, 0, -1) end
        if input.KeyCode == Enum.KeyCode.S then moveDirection = moveDirection - Vector3.new(0, 0, 1) end
        if input.KeyCode == Enum.KeyCode.A then moveDirection = moveDirection - Vector3.new(-1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveDirection = moveDirection - Vector3.new(1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDirection = moveDirection - Vector3.new(0, -1, 0) end
    end)
    
    local renderStep = RunService.RenderStepped:Connect(function()
        if not flying or not bodyVelocity then return end
        local camCFrame = Camera.CFrame
        local forward = camCFrame.LookVector
        local right = camCFrame.RightVector
        local up = camCFrame.UpVector
        
        local vel = (forward * moveDirection.Z + right * moveDirection.X + up * moveDirection.Y) * flySpeed
        bodyVelocity.Velocity = vel
        if bg then bg.CFrame = camCFrame end
    end)
    
    -- Connections speichern zum späteren Beenden
    espObjects["flyConnections"] = {inputBegan, inputEnded, renderStep}
end

local function stopFly()
    flying = false
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bg then bg:Destroy() bg = nil end
    
    if espObjects["flyConnections"] then
        for _, conn in pairs(espObjects["flyConnections"]) do
            if conn then conn:Disconnect() end
        end
        espObjects["flyConnections"] = nil
    end
end

-- Fling Funktion
local function fling()
    if flingActive then return end
    flingActive = true
    local char = LocalPlayer.Character
    if not char then flingActive = false return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then flingActive = false return end
    
    local flingVelocity = Instance.new("BodyVelocity")
    flingVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
    flingVelocity.Velocity = Vector3.new(0, 150, 0)
    flingVelocity.Parent = rootPart
    
    task.wait(0.1)
    flingVelocity:Destroy()
    
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1, 1, 1) * 100000
    bp.Position = rootPart.Position + Vector3.new(0, 50, 0)
    bp.Parent = rootPart
    
    task.wait(0.3)
    bp:Destroy()
    flingActive = false
end

-- WICHTIG: Hier wird das Fenster mit der TOGGLE-Taste erstellt
local Window = Rayfield:CreateWindow({
    Name = "Advanced Script",
    LoadingTitle = "Rayfield Script",
    LoadingSubtitle = "by Developer",
    ToggleUIKeybind = "K",  -- Drücke K zum Ein-/Ausblenden des GUIs!
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfieldScript",
        FileName = "Settings"
    }
})

local MainTab = Window:CreateTab("Main")
local VisualsTab = Window:CreateTab("Visuals")
local MovementTab = Window:CreateTab("Movement")

-- Main Tab
MainTab:CreateButton({
    Name = "Fling (Explosionssprung)",
    Callback = function()
        fling()
    end,
})

MainTab:CreateButton({
    Name = "Refresh ESP",
    Callback = function()
        refreshESP()
    end,
})

-- Visuals Tab
VisualsTab:CreateToggle({
    Name = "ESP aktivieren",
    CurrentValue = espEnabled,
    Flag = "ESPToggle",
    Callback = function(value)
        espEnabled = value
        if espEnabled then
            refreshESP()
        else
            for player, _ in pairs(espObjects) do
                if player ~= "flyConnections" then
                    removeESP(player)
                end
            end
        end
    end
})

-- Movement Tab
MovementTab:CreateSlider({
    Name = "Speed (1-500, Standard 100)",
    Range = {1, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 100,
    Flag = "SpeedSlider",
    Callback = function(value)
        setSpeed(value)
    end
})

MovementTab:CreateToggle({
    Name = "Fly Modus",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        if value then
            startFly()
        else
            stopFly()
        end
    end
})

-- Events
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

-- Initialisierung
task.wait(1)
refreshESP()
setSpeed(100)

-- Erfolgsmeldung
Rayfield:Notify({
    Title = "Script geladen",
    Content = "Drücke K zum Öffnen/Schließen des Menüs!",
    Duration = 5
})