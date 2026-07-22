local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "✨ Ruby HUB",
   Icon = 0,
   LoadingTitle = "Ruby HUB",
   LoadingSubtitle = "by lechayy",
   ShowText = "Ruby",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Movement = Window:CreateTab("🚀 Movement", 4483362458)
local Visuals = Window:CreateTab("👁️ Visuals", 4483362458)
local Utility = Window:CreateTab("🛡️ Utility", 4483362458)
local Settings = Window:CreateTab("⚙️ Settings", 4483362458)

-- ================================================
-- MOVEMENT
-- ================================================
Movement:CreateSection("✈️ Flight")

local flyEnabled = false
local flyMaxSpeed = 50
local flyBodyGyro, flyBodyVelocity, flyConnection

local function startFly()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        humanoid:SetStateEnabled(state, false)
    end
    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    char.Animate.Disabled = true

    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return end

    flyBodyGyro = Instance.new("BodyGyro", torso)
    flyBodyGyro.P = 9e4
    flyBodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.cframe = torso.CFrame

    flyBodyVelocity = Instance.new("BodyVelocity", torso)
    flyBodyVelocity.velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

    humanoid.PlatformStand = true

    flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not flyEnabled then return end
        local uis = game:GetService("UserInputService")
        local f = uis:IsKeyDown(Enum.KeyCode.W) and 1 or 0
        local b = uis:IsKeyDown(Enum.KeyCode.S) and 1 or 0
        local l = uis:IsKeyDown(Enum.KeyCode.A) and 1 or 0
        local r = uis:IsKeyDown(Enum.KeyCode.D) and 1 or 0

        local forward = (f - b) * flyMaxSpeed
        local right = (r - l) * flyMaxSpeed
        local up = 0
        if uis:IsKeyDown(Enum.KeyCode.Space) then up = flyMaxSpeed end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then up = -flyMaxSpeed end

        local cam = workspace.CurrentCamera
        local vel = cam.CFrame.LookVector * forward + cam.CFrame.RightVector * right + Vector3.new(0, up, 0)
        if vel.Magnitude > flyMaxSpeed then vel = vel.Unit * flyMaxSpeed end
        flyBodyVelocity.velocity = vel
        flyBodyGyro.cframe = cam.CFrame
    end)
end

local function stopFly()
    flyEnabled = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end

    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                humanoid:SetStateEnabled(state, true)
            end
            humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            humanoid.PlatformStand = false
        end
        char.Animate.Disabled = false
    end
end

Movement:CreateToggle({
    Name = "🛸 Fly Mode",
    CurrentValue = false,
    Flag = "FlyMode",
    Callback = function(Value)
        flyEnabled = Value
        if Value then startFly() else stopFly() end
    end,
})

Movement:CreateSlider({
    Name = "🏃 Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = " stud/s",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value) flyMaxSpeed = Value end,
})

Movement:CreateSection("🏃 Speed & Jump")

local walkSpeedValue = 16
local jumpPowerValue = 50
local antiCheatConnection

Movement:CreateSlider({
    Name = "👟 Walk Speed",
    Range = {16, 250},
    Increment = 1,
    Suffix = " stud/s",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        walkSpeedValue = Value
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
        if not antiCheatConnection then
            antiCheatConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.WalkSpeed ~= walkSpeedValue then
                    char.Humanoid.WalkSpeed = walkSpeedValue
                end
            end)
        end
    end,
})

Movement:CreateSlider({
    Name = "⬆️ Jump Power",
    Range = {50, 300},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        jumpPowerValue = Value
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
        if not antiCheatConnection then
            antiCheatConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.JumpPower ~= jumpPowerValue then
                    char.Humanoid.JumpPower = jumpPowerValue
                end
            end)
        end
    end,
})

Movement:CreateToggle({
    Name = "🔄 Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        if Value then
            local canJump = true
            local jumpCooldown = 0.3
            local function onJumpRequest()
                if canJump then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    canJump = false
                    task.wait(jumpCooldown)
                    canJump = true
                end
            end
            _G.InfJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)
        else
            if _G.InfJumpConnection then
                _G.InfJumpConnection:Disconnect()
                _G.InfJumpConnection = nil
            end
        end
    end,
})

Movement:CreateToggle({
    Name = "🧱 NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char then return end

        if Value then
            _G.NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
                if not Value then return end
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            if _G.NoClipConnection then
                _G.NoClipConnection:Disconnect()
                _G.NoClipConnection = nil
            end
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

-- ================================================
-- VISUALS
-- ================================================
Visuals:CreateSection("👁️ ESP & Visuals")

local espObjects = {}
local espEnabled = false
local espConnections = {}

local function createESP(playerObj)
    if playerObj == game.Players.LocalPlayer then return end
    local character = playerObj.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if espObjects[playerObj] then
        for _, obj in pairs(espObjects[playerObj]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        espObjects[playerObj] = nil
    end

    local espTable = {}

    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 5, 2)
    box.Adornee = root
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.5
    box.ZIndex = 0
    box.AlwaysOnTop = true
    box.Parent = root
    espTable.box = box

    local nameTag = Instance.new("BillboardGui")
    nameTag.Size = UDim2.new(0, 200, 0, 50)
    nameTag.Adornee = root
    nameTag.StudsOffset = Vector3.new(0, 3, 0)
    nameTag.AlwaysOnTop = true
    local label = Instance.new("TextLabel", nameTag)
    label.Text = playerObj.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.5
    nameTag.Parent = root
    espTable.nameTag = nameTag

    espObjects[playerObj] = espTable
end

local function clearAllESP()
    for player, espData in pairs(espObjects) do
        if espData.box and espData.box.Parent then espData.box:Destroy() end
        if espData.nameTag and espData.nameTag.Parent then espData.nameTag:Destroy() end
    end
    espObjects = {}
end

local function updateESP(enable)
    if enable then
        for _, plr in pairs(game.Players:GetPlayers()) do
            createESP(plr)
        end
        espConnections.PlayerAdded = game.Players.PlayerAdded:Connect(createESP)
        espConnections.PlayerRemoving = game.Players.PlayerRemoving:Connect(function(plr)
            if espObjects[plr] then
                for _, obj in pairs(espObjects[plr]) do
                    if obj and obj.Parent then obj:Destroy() end
                end
                espObjects[plr] = nil
            end
        end)
    else
        clearAllESP()
        if espConnections.PlayerAdded then espConnections.PlayerAdded:Disconnect() end
        if espConnections.PlayerRemoving then espConnections.PlayerRemoving:Disconnect() end
    end
end

Visuals:CreateToggle({
    Name = "📦 ESP (Box + Name)",
    CurrentValue = false,
    Flag = "ESP_Master",
    Callback = function(Value)
        espEnabled = Value
        updateESP(Value)
    end,
})

local wallhackEnabled = false
local wallhackParts = {}
local wallhackConnection

local function applyWallhack(enable)
    if enable then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency < 1 then
                obj.Transparency = 0.5
                wallhackParts[obj] = true
            end
        end
        wallhackConnection = workspace.DescendantAdded:Connect(function(child)
            if wallhackEnabled and child:IsA("BasePart") and child.Transparency < 1 then
                child.Transparency = 0.5
                wallhackParts[child] = true
            end
        end)
    else
        if wallhackConnection then wallhackConnection:Disconnect() wallhackConnection = nil end
        for part, _ in pairs(wallhackParts) do
            if part and part.Parent then
                part.Transparency = 0
            end
        end
        wallhackParts = {}
    end
end

Visuals:CreateToggle({
    Name = "👻 Wallhack",
    CurrentValue = false,
    Flag = "Wallhack",
    Callback = function(Value)
        wallhackEnabled = Value
        applyWallhack(Value)
    end,
})

Visuals:CreateSlider({
    Name = "🔭 FOV (Field of View)",
    Range = {1, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        game.Workspace.CurrentCamera.FieldOfView = Value
    end,
})

-- ================================================
-- UTILITY
-- ================================================
Utility:CreateSection("🛡️ Other")

local antiAFKEnabled = false
local antiAFKConnection

Utility:CreateToggle({
    Name = "⏳ Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        antiAFKEnabled = Value
        if Value then
            antiAFKConnection = game:GetService("RunService").Heartbeat:Connect(function() end)
        else
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
                antiAFKConnection = nil
            end
        end
    end,
})

-- ================================================
-- SETTINGS
-- ================================================
Settings:CreateSection("⚙️ General")

Settings:CreateButton({
    Name = "💾 Save Configuration",
    Callback = function() Rayfield:SaveConfiguration() end,
})

Settings:CreateButton({
    Name = "📂 Load Configuration",
    Callback = function() Rayfield:LoadConfiguration() end,
})

Settings:CreateLabel("✨ Ruby HUB v1.0\n👤 Developer: lechayy\n⚡ Powered by Rayfield")

-- ================================================
-- ВОССТАНОВЛЕНИЕ ПОСЛЕ СМЕРТИ (исправлено)
-- ================================================
local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function(char)
    task.wait(0.5)

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- 1. Сначала отключаем старые соединения для полёта
    stopFly()

    -- 2. Восстанавливаем Walk Speed и Jump Power
    local walkSpeed = Rayfield:GetFlag("WalkSpeed") or 16
    humanoid.WalkSpeed = walkSpeed
    local jumpPower = Rayfield:GetFlag("JumpPower") or 50
    humanoid.JumpPower = jumpPower

    -- 3. Восстанавливаем Fly (если был включён)
    if Rayfield:GetFlag("FlyMode") then
        flyEnabled = true
        startFly()
    end

    -- 4. Восстанавливаем NoClip (если был включён)
    if Rayfield:GetFlag("NoClip") then
        if _G.NoClipConnection then
            _G.NoClipConnection:Disconnect()
            _G.NoClipConnection = nil
        end
        _G.NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
            if not Rayfield:GetFlag("NoClip") then return end
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 5. Восстанавливаем Infinite Jump (если был включён)
    if Rayfield:GetFlag("InfJump") then
        if _G.InfJumpConnection then
            _G.InfJumpConnection:Disconnect()
            _G.InfJumpConnection = nil
        end
        local canJump = true
        local jumpCooldown = 0.3
        local function onJumpRequest()
            if canJump then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                canJump = false
                task.wait(jumpCooldown)
                canJump = true
            end
        end
        _G.InfJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)
    end
end)
