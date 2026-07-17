-- AMNYAM HUB v1.3 | mm2
-- Advanced GUI for Roblox

local AMNYAM_HUB = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Colors
local C = {
    Cyan    = Color3.fromRGB(47, 224, 208),
    Blue    = Color3.fromRGB(47, 209, 255),
    Teal    = Color3.fromRGB(61, 255, 176),
    Purple  = Color3.fromRGB(155, 92, 255),
    Pink    = Color3.fromRGB(255, 79, 216),
    Yellow  = Color3.fromRGB(255, 210, 63),
    Deep    = Color3.fromRGB(12, 43, 48),
    Text    = Color3.fromRGB(234, 255, 251),
    Muted   = Color3.fromRGB(159, 214, 195),
    On      = Color3.fromRGB(61, 255, 176),
    Off     = Color3.fromRGB(255, 84, 112),
    Panel   = Color3.fromRGB(8, 26, 24),
    Panel2  = Color3.fromRGB(14, 38, 34),
    Line    = Color3.fromRGB(47, 209, 255),
    Bg      = Color3.fromRGB(3, 10, 18),
}

local function new(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
        inst.AutoLocalize = false
    end
    return inst
end

local function tween(inst, props, dur, style, dir)
    local t = TweenService:Create(inst, TweenInfo.new(
        dur or 0.25,
        style or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

-- ===== MINIMALIST ICONS =====
local function makeEye(parent, color)
    local c = new("Frame", {Parent = parent, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ZIndex = parent.ZIndex + 1})
    local eye = new("Frame", {Parent = c, AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.new(0,16,0,10), Position = UDim2.new(0.5,0,0.5,0), BackgroundTransparency = 1, ZIndex = c.ZIndex})
    new("UICorner", {Parent = eye, CornerRadius = UDim.new(0.5,0)})
    new("UIStroke", {Parent = eye, Color = color, Thickness = 1.6, LineJoinMode = Enum.LineJoinMode.Round})
    local pupil = new("Frame", {Parent = c, AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.new(0,5,0,5), Position = UDim2.new(0.5,0,0.5,0), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = c.ZIndex + 1})
    new("UICorner", {Parent = pupil, CornerRadius = UDim.new(1,0)})
end

-- Beautiful Exit Icon (stylized X with glow)
local function makeExitIcon(parent, color)
    local c = new("Frame", {Parent = parent, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ZIndex = parent.ZIndex + 1})
    
    local size = 14
    local thickness = 2.2
    
    local line1 = new("Frame", {
        Parent = c, 
        AnchorPoint = Vector2.new(0.5,0.5), 
        Size = UDim2.new(0, size, 0, thickness), 
        Position = UDim2.new(0.5, 0, 0.5, 0), 
        BackgroundColor3 = color, 
        BorderSizePixel = 0, 
        ZIndex = c.ZIndex,
        Rotation = 45
    })
    new("UICorner", {Parent = line1, CornerRadius = UDim.new(1,0)})
    
    local line2 = new("Frame", {
        Parent = c, 
        AnchorPoint = Vector2.new(0.5,0.5), 
        Size = UDim2.new(0, size, 0, thickness), 
        Position = UDim2.new(0.5, 0, 0.5, 0), 
        BackgroundColor3 = color, 
        BorderSizePixel = 0, 
        ZIndex = c.ZIndex,
        Rotation = -45
    })
    new("UICorner", {Parent = line2, CornerRadius = UDim.new(1,0)})
    
    local glow = new("Frame", {
        Parent = c,
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        ZIndex = c.ZIndex - 1
    })
    new("UICorner", {Parent = glow, CornerRadius = UDim.new(1,0)})
    local glowStroke = new("UIStroke", {Parent = glow, Color = color, Thickness = 1, Transparency = 0.8})
    
    return {line1 = line1, line2 = line2, glow = glow, glowStroke = glowStroke}
end

-- ===== POSITION SAVE/LOAD =====
local POS_FILE = "amnyam_hub_pos.json"

local function saveDragPos(pos)
    pcall(function()
        local data = {X = pos.X.Offset, Y = pos.Y.Offset}
        writefile(POS_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadDragPos()
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(POS_FILE))
    end)
    if success and data and data.X and data.Y then
        return UDim2.new(0, data.X, 0, data.Y)
    end
    return UDim2.new(0, 20, 0, 20)
end

-- ===== CREATE =====
function AMNYAM_HUB:Create()
    local sg = new("ScreenGui", {
        Name = "AMNYAM_HUB", 
        Parent = PlayerGui, 
        ResetOnSpawn = false, 
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, 
        AutoLocalize = false, 
        IgnoreGuiInset = true
    })

    -- Main frame
    local main = new("Frame", {
        Name = "Main", 
        Parent = sg, 
        Size = UDim2.new(1, -60, 1, -60),
        Position = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = C.Bg, 
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true
    })
    
    -- ROUNDED CORNERS
    new("UICorner", {Parent = main, CornerRadius = UDim.new(0, 18)})

    -- ROUNDED ANIMATED BORDER
    local mainStroke = new("UIStroke", {
        Parent = main, 
        Color = C.Cyan, 
        Thickness = 1.5, 
        Transparency = 0.3,
        LineJoinMode = Enum.LineJoinMode.Round
    })
    
    -- Living glow
    spawn(function()
        while true do
            tween(mainStroke, {Color = C.Teal}, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(2.5)
            tween(mainStroke, {Color = C.Blue}, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(2.5)
            tween(mainStroke, {Color = C.Cyan}, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(2.5)
        end
    end)

    new("UIGradient", {Parent = main, Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(7,21,34)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(4,18,32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(3,10,18))
    }), Rotation = 160})

    -- Clip container for radial glows — NOW WITH Rounded Corners so ovals don't peek out
    local bgClip = new("Frame", {
        Parent = main, 
        Name = "BgClip", 
        Size = UDim2.new(1, 0, 1, 0), 
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1, 
        BorderSizePixel = 0, 
        ClipsDescendants = true, 
        ZIndex = 0
    })
    new("UICorner", {Parent = bgClip, CornerRadius = UDim.new(0, 18)})

    local function radial(col, alpha, cx, cy, sz)
        local f = new("Frame", {Parent = bgClip, Size = UDim2.new(sz,0,sz,0), Position = UDim2.new(cx-sz/2,0,cy-sz/2,0), BackgroundColor3 = col, BackgroundTransparency = 1-alpha, BorderSizePixel = 0, ZIndex = 0})
        new("UICorner", {Parent = f, CornerRadius = UDim.new(1,0)})
    end
    radial(C.Teal, 0.16, 0.15, 0.15, 0.45)
    radial(C.Blue, 0.22, 0.85, 0.15, 0.45)
    radial(C.Cyan, 0.16, 0.85, 0.85, 0.50)
    radial(C.Blue, 0.18, 0.15, 0.85, 0.45)
    radial(C.Blue, 0.08, 0.50, 0.50, 0.60)

    -- Particles
    local pFolder = new("Folder", {Parent = main, Name = "Particles"})
    local pColors = {C.Cyan, C.Blue, C.Teal, C.Purple, C.Pink, C.Yellow}
    for i = 1, 26 do
        local p = new("Frame", {Parent = pFolder, Size = UDim2.new(0,2,0,2), Position = UDim2.new(math.random(),0,1.1,0), BackgroundColor3 = pColors[math.random(#pColors)], BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 1})
        new("UICorner", {Parent = p, CornerRadius = UDim.new(1,0)})
        spawn(function()
            while true do
                local dur = 6 + math.random() * 5
                local x = math.random()
                p.Position = UDim2.new(x,0,1.1,0); p.BackgroundTransparency = 1
                tween(p, {BackgroundTransparency = 0.5}, dur * 0.1)
                wait(dur * 0.1)
                tween(p, {Position = UDim2.new(x,0,-0.1,0)}, dur * 0.8, Enum.EasingStyle.Linear)
                wait(dur * 0.7)
                tween(p, {BackgroundTransparency = 1}, dur * 0.1)
                wait(dur * 0.2)
            end
        end)
    end

    -- ===== DRAG BAR =====
    local dragBar = new("Frame", {
        Parent = main,
        Name = "DragBar",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 50,
        Active = false
    })

    -- Exit Button
    local exitBtn = new("TextButton", {
        Parent = main, 
        Name = "ExitBtn", 
        Size = UDim2.new(0, 36, 0, 36), 
        Position = UDim2.new(1, -48, 0, 10), 
        BackgroundColor3 = Color3.fromRGB(10, 30, 32), 
        BackgroundTransparency = 0.15, 
        BorderSizePixel = 0, 
        Text = "", 
        ZIndex = 51, 
        AutoLocalize = false
    })
    new("UICorner", {Parent = exitBtn, CornerRadius = UDim.new(0, 10)})
    new("UIStroke", {Parent = exitBtn, Color = C.Off, Transparency = 0.6, Thickness = 1})
    
    local exitIconParts = makeExitIcon(exitBtn, C.Off)

    exitBtn.MouseEnter:Connect(function() 
        tween(exitBtn, {BackgroundTransparency = 0.35}, 0.2)
        tween(exitIconParts.glowStroke, {Transparency = 0.4}, 0.2)
    end)
    exitBtn.MouseLeave:Connect(function() 
        tween(exitBtn, {BackgroundTransparency = 0.15}, 0.2)
        tween(exitIconParts.glowStroke, {Transparency = 0.8}, 0.2)
    end)

    -- ===== MAIN GUI DRAG LOGIC =====
    local mainDragging = false
    local dragStartCursor = nil
    local dragStartPos = nil
    local dragConnection = nil

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        
        mainDragging = true
        dragStartCursor = Vector2.new(input.Position.X, input.Position.Y)
        dragStartPos = Vector2.new(main.Position.X.Offset, main.Position.Y.Offset)
        
        if dragConnection then dragConnection:Disconnect() end
        
        dragConnection = UserInputService.InputChanged:Connect(function(changedInput)
            if not mainDragging then return end
            if changedInput.UserInputType ~= Enum.UserInputType.MouseMovement and changedInput.UserInputType ~= Enum.UserInputType.Touch then return end
            
            local currentCursor = Vector2.new(changedInput.Position.X, changedInput.Position.Y)
            local delta = currentCursor - dragStartCursor
            local newPos = dragStartPos + delta
            
            main.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
        end)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mainDragging = false
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil
            end
        end
    end)

    -- ===== DRAGGABLE MINIMIZE BUTTON =====
    local dragGui = new("ScreenGui", {
        Name = "AMNYAM_Drag", 
        Parent = PlayerGui, 
        ResetOnSpawn = false, 
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, 
        AutoLocalize = false, 
        Enabled = false
    })

    local savedPos = loadDragPos()

    local dragBtn = new("TextButton", {
        Parent = dragGui, 
        Name = "DragBtn",
        Size = UDim2.new(0, 50, 0, 50),
        Position = savedPos,
        BackgroundColor3 = C.Panel,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 100,
        AutoLocalize = false,
    })
    new("UICorner", {Parent = dragBtn, CornerRadius = UDim.new(0, 14)})
    new("UIStroke", {Parent = dragBtn, Color = C.Line, Transparency = 0.5, Thickness = 1.5})

    local dragShadow = new("Frame", {
        Parent = dragGui,
        Size = UDim2.new(0, 50, 0, 50),
        Position = dragBtn.Position,
        BackgroundColor3 = C.Blue,
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 99,
    })
    new("UICorner", {Parent = dragShadow, CornerRadius = UDim.new(0, 14)})

    -- Amnyam Icon Image (drag button)
    local dragImg = new("ImageLabel", {
        Parent = dragBtn,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0.5, -20, 0.5, -20),
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 101,
    })

    -- Fallback letter
    local fallbackLabel = new("TextLabel", {
        Parent = dragBtn,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "A",
        TextColor3 = C.Cyan,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        ZIndex = 102,
        AutoLocalize = false,
    })

    -- ===== SIDEBAR =====
    local sidebar = new("Frame", {
        Parent = main, 
        Size = UDim2.new(0,190,1,0), 
        BackgroundColor3 = C.Panel, 
        BackgroundTransparency = 0.45, 
        BorderSizePixel = 0, 
        ZIndex = 2
    })
    new("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0, 18)})
    new("UIStroke", {Parent = sidebar, Color = C.Line, Transparency = 0.6, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

    local brand = new("Frame", {Parent = sidebar, Size = UDim2.new(1,-20,0,42), Position = UDim2.new(0,10,0,14), BackgroundTransparency = 1, ZIndex = 3})
    
    -- Amnyam icon in brand (same image as drag button)
    local brandImg = new("ImageLabel", {
        Parent = brand,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 4
    })
    new("UICorner", {Parent = brandImg, CornerRadius = UDim.new(0, 8)})
    
    -- Fallback colored square if image fails to load
    local fallbackLogo = new("Frame", {
        Parent = brand,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.Cyan,
        BorderSizePixel = 0,
        ZIndex = 4
    })
    new("UICorner", {Parent = fallbackLogo, CornerRadius = UDim.new(0, 8)})
    local logoGrad = new("UIGradient", {Parent = fallbackLogo, Color = ColorSequence.new{ColorSequenceKeypoint.new(0,C.Cyan),ColorSequenceKeypoint.new(0.5,C.Teal),ColorSequenceKeypoint.new(1,C.Cyan)}, Rotation = 180})
    spawn(function() while true do tween(logoGrad, {Rotation = logoGrad.Rotation + 360}, 6, Enum.EasingStyle.Linear) wait(6) end end)

    local brandText = new("Frame", {Parent = brand, Size = UDim2.new(1,-36,1,0), Position = UDim2.new(0,36,0,0), BackgroundTransparency = 1, ZIndex = 4})
    new("TextLabel", {Parent = brandText, Size = UDim2.new(1,0,0,18), Position = UDim2.new(0,0,0,2), BackgroundTransparency = 1, Text = "AMNYAM ", TextColor3 = C.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, AutoLocalize = false})
    new("TextLabel", {Parent = brandText, Size = UDim2.new(0,40,0,18), Position = UDim2.new(0,58,0,2), BackgroundTransparency = 1, Text = "HUB", TextColor3 = C.Cyan, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, AutoLocalize = false})
    new("TextLabel", {Parent = brandText, Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,0,20), BackgroundTransparency = 1, Text = "v1.3 | Universal", TextColor3 = C.Muted, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, AutoLocalize = false})

    -- Try to load amnyam image from URL (used for both drag button and brand)
    spawn(function()
        local success = pcall(function()
            local url = "https://raw.githubusercontent.com/MrDani307/CodeMm2/refs/heads/main/amnyam.png"
            local fileName = "amnyam_hub_icon.png"
            writefile(fileName, game:HttpGet(url))
            local assetPath = getcustomasset(fileName)
            dragImg.Image = assetPath
            brandImg.Image = assetPath
            fallbackLabel.Visible = false
            fallbackLogo.Visible = false
        end)
        if not success then
            dragImg.Image = "rbxassetid://0"
            brandImg.Image = "rbxassetid://0"
        end
    end)

    local nav = new("Frame", {Parent = sidebar, Size = UDim2.new(1,-20,1,-100), Position = UDim2.new(0,10,0,65), BackgroundTransparency = 1, ZIndex = 3})
    new("UIListLayout", {Parent = nav, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})

    local visTab = new("TextButton", {Parent = nav, Size = UDim2.new(1,0,0,40), BackgroundColor3 = C.Blue, BackgroundTransparency = 0.72, BorderSizePixel = 0, Text = "", LayoutOrder = 1, ZIndex = 4, AutoLocalize = false})
    new("UICorner", {Parent = visTab, CornerRadius = UDim.new(0,12)})
    new("UIStroke", {Parent = visTab, Color = C.Blue, Transparency = 0.45, Thickness = 1})
    new("UIGradient", {Parent = visTab, Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(47,209,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(47,224,208))}, Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.72),NumberSequenceKeypoint.new(1,0.86)}})

    local visIconContainer = new("Frame", {Parent = visTab, Size = UDim2.new(0,18,0,18), Position = UDim2.new(0,12,0.5,-9), BackgroundTransparency = 1, ZIndex = 5})
    makeEye(visIconContainer, C.Text)

    new("TextLabel", {Parent = visTab, Size = UDim2.new(1,-40,1,0), Position = UDim2.new(0,38,0,0), BackgroundTransparency = 1, Text = "Visuals", TextColor3 = Color3.fromRGB(255,255,255), TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, AutoLocalize = false})
    new("UIStroke", {Parent = visTab, Color = C.Blue, Transparency = 0.6, Thickness = 1})

    local foot = new("Frame", {Parent = sidebar, Size = UDim2.new(1,-20,0,20), Position = UDim2.new(0,10,1,-34), BackgroundTransparency = 1, ZIndex = 3})
    local dot = new("Frame", {Parent = foot, Size = UDim2.new(0,6,0,6), Position = UDim2.new(0,0,0.5,-3), BackgroundColor3 = C.On, BorderSizePixel = 0, ZIndex = 4})
    new("UICorner", {Parent = dot, CornerRadius = UDim.new(1,0)})
    local dotGlow = new("UIStroke", {Parent = dot, Color = C.On, Transparency = 0.5, Thickness = 2})
    spawn(function()
        while true do
            tween(dot, {Size = UDim2.new(0,4,0,4), Position = UDim2.new(0,1,0.5,-2)}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            tween(dotGlow, {Transparency = 0.8}, 0.8)
            wait(0.8)
            tween(dot, {Size = UDim2.new(0,6,0,6), Position = UDim2.new(0,0,0.5,-3)}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            tween(dotGlow, {Transparency = 0.5}, 0.8)
            wait(0.8)
        end
    end)
    new("TextLabel", {Parent = foot, Size = UDim2.new(1,-12,1,0), Position = UDim2.new(0,12,0,0), BackgroundTransparency = 1, Text = "Connected", TextColor3 = C.Muted, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, AutoLocalize = false})

    -- ===== CONTENT =====
    local content = new("Frame", {Parent = main, Size = UDim2.new(1,-190,1,0), Position = UDim2.new(0,190,0,0), BackgroundTransparency = 1, ZIndex = 2})

    local header = new("Frame", {Parent = content, Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3})
    new("UIStroke", {Parent = header, Color = C.Line, Transparency = 0.6, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    
    new("TextLabel", {Parent = header, Size = UDim2.new(1,-40,0,22), Position = UDim2.new(0,20,0,10), BackgroundTransparency = 1, Text = "Visuals", TextColor3 = C.Text, TextSize = 16, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, AutoLocalize = false})
    new("TextLabel", {Parent = header, Size = UDim2.new(1,-40,0,16), Position = UDim2.new(0,20,0,30), BackgroundTransparency = 1, Text = "Display Settings", TextColor3 = C.Muted, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, AutoLocalize = false})

    local rows = new("ScrollingFrame", {Parent = content, Size = UDim2.new(1,-40,1,-60), Position = UDim2.new(0,20,0,55), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 5, ScrollBarImageColor3 = C.Cyan, ScrollBarImageTransparency = 0.65, CanvasSize = UDim2.new(0,0,0,320), ZIndex = 3})
    new("UIListLayout", {Parent = rows, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})

    local function CreateToggle(name, defaultOn, order)
        local row = new("Frame", {Parent = rows, Name = name, Size = UDim2.new(1,0,0,48), BackgroundColor3 = C.Panel2, BackgroundTransparency = 0.6, BorderSizePixel = 0, LayoutOrder = order, ZIndex = 5})
        new("UICorner", {Parent = row, CornerRadius = UDim.new(0,14)})
        local rowStroke = new("UIStroke", {Parent = row, Color = C.Cyan, Transparency = 0.8, Thickness = 1})
        new("TextLabel", {Parent = row, Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,16,0,0), BackgroundTransparency = 1, Text = name, TextColor3 = C.Text, TextSize = 13, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, AutoLocalize = false})

        local state = defaultOn
        local toggle = new("TextButton", {Parent = row, Name = "Toggle", Size = UDim2.new(0,46,0,24), Position = UDim2.new(1,-62,0.5,-12), BackgroundColor3 = state and C.On or C.Off, BorderSizePixel = 0, Text = "", ZIndex = 6, AutoLocalize = false})
        new("UICorner", {Parent = toggle, CornerRadius = UDim.new(1,0)})
        local circle = new("Frame", {Parent = toggle, Name = "Circle", Size = UDim2.new(0,18,0,18), Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, ZIndex = 7})
        new("UICorner", {Parent = circle, CornerRadius = UDim.new(1,0)})
        local tGlow = new("UIStroke", {Parent = toggle, Color = state and C.On or C.Off, Transparency = 0.3, Thickness = 1})

        toggle.MouseButton1Click:Connect(function()
            state = not state
            tween(toggle, {BackgroundColor3 = state and C.On or C.Off}, 0.25)
            tween(circle, {Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            tween(tGlow, {Color = state and C.On or C.Off}, 0.25)
        end)

        row.MouseEnter:Connect(function() tween(rowStroke, {Transparency = 0.5}, 0.2) end)
        row.MouseLeave:Connect(function() tween(rowStroke, {Transparency = 0.8}, 0.2) end)
        return toggle
    end

    CreateToggle("Cham Everyone", true, 1)
    CreateToggle("Cham Murderer Only", false, 2)
    CreateToggle("Cham Sheriff Only", false, 3)
    CreateToggle("Cham Coins", false, 4)
    CreateToggle("Outline", true, 5)

    local note = new("Frame", {Parent = rows, Name = "Note", Size = UDim2.new(1,0,0,60), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.97, BorderSizePixel = 0, LayoutOrder = 6, ZIndex = 5})
    new("UICorner", {Parent = note, CornerRadius = UDim.new(0,12)})
    new("UIStroke", {Parent = note, Color = C.Cyan, Transparency = 0.7, Thickness = 1})
    new("TextLabel", {Parent = note, Size = UDim2.new(1,-28,0,18), Position = UDim2.new(0,14,0,8), BackgroundTransparency = 1, Text = "Outline", TextColor3 = C.Cyan, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, AutoLocalize = false})
    new("TextLabel", {Parent = note, Size = UDim2.new(1,-28,0,30), Position = UDim2.new(0,14,0,26), BackgroundTransparency = 1, Text = "May not work on some devices or 32-bit executors.", TextColor3 = C.Muted, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 6, AutoLocalize = false})

    -- Minimize button drag logic (delta-based)
    local miniDragging = false
    local miniDragStartCursor = nil
    local miniDragStartPos = nil
    local miniDragConnection = nil

    dragBtn.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        
        miniDragging = true
        miniDragStartCursor = Vector2.new(input.Position.X, input.Position.Y)
        miniDragStartPos = Vector2.new(dragBtn.Position.X.Offset, dragBtn.Position.Y.Offset)
        
        if miniDragConnection then miniDragConnection:Disconnect() end
        
        miniDragConnection = UserInputService.InputChanged:Connect(function(changedInput)
            if not miniDragging then return end
            if changedInput.UserInputType ~= Enum.UserInputType.MouseMovement and changedInput.UserInputType ~= Enum.UserInputType.Touch then return end
            
            local currentCursor = Vector2.new(changedInput.Position.X, changedInput.Position.Y)
            local delta = currentCursor - miniDragStartCursor
            local newPos = miniDragStartPos + delta
            
            dragBtn.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
            dragShadow.Position = dragBtn.Position
        end)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if miniDragging then
                saveDragPos(dragBtn.Position)
            end
            miniDragging = false
            if miniDragConnection then
                miniDragConnection:Disconnect()
                miniDragConnection = nil
            end
        end
    end)

    -- Click to restore (only if not dragged)
    local clickStartPos = nil
    dragBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            clickStartPos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)

    dragBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local endPos = Vector2.new(input.Position.X, input.Position.Y)
            if (endPos - clickStartPos).Magnitude < 5 then
                main.Visible = true
                dragGui.Enabled = false
            end
        end
    end)

    -- Exit click
    exitBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        dragGui.Enabled = true
        
        local targetPos = loadDragPos()
        
        dragBtn.Size = UDim2.new(0, 40, 0, 40)
        dragBtn.Position = targetPos
        dragShadow.Size = UDim2.new(0, 40, 0, 40)
        dragShadow.Position = dragBtn.Position
        
        tween(dragBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tween(dragShadow, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    -- Intro animation
    main.Size = UDim2.new(1, -60, 1, -60)
    main.Position = UDim2.new(0, 30, 0, 30)
    tween(main, {Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20)}, 0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

    return {Destroy = function() sg:Destroy() dragGui:Destroy() end, ScreenGui = sg}
end

local Hub = AMNYAM_HUB:Create()
print("AMNYAM HUB v1.3 | Loaded")
