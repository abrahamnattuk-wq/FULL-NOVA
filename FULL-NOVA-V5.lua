
--[[
    FULL NOVA V5
    Standalone Roblox Studio GUI
    Manual message capture prototype
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("FULL_NOVA_V5")
if old then old:Destroy() end

local connections = {}

local function track(connection)
    table.insert(connections, connection)
    return connection
end

local function cleanup()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    table.clear(connections)
end

local PURPLE = Color3.fromRGB(145, 85, 255)
local DARK = Color3.fromRGB(20, 17, 29)
local PANEL = Color3.fromRGB(34, 28, 47)
local WHITE = Color3.fromRGB(245, 240, 255)
local MUTED = Color3.fromRGB(170, 155, 195)

local gui = Instance.new("ScreenGui")
gui.Name = "FULL_NOVA_V5"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = object
end

local function label(parent, text, size, position, fontSize)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Size = size
    l.Position = position
    l.TextColor3 = WHITE
    l.Font = Enum.Font.Gotham
    l.TextSize = fontSize or 13
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function button(parent, text, size, position)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = PURPLE
    b.Text = text
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = true
    b.Parent = parent
    corner(b, 8)
    return b
end

-- Main window

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(260, 325)
main.Position = UDim2.new(0.5, -130, 0.5, -162)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 13)

local outline = Instance.new("UIStroke")
outline.Color = PURPLE
outline.Thickness = 1.5
outline.Parent = main

-- Header

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 43)
header.BackgroundColor3 = PANEL
header.BorderSizePixel = 0
header.Parent = main
corner(header, 12)

label(header, "✦ FULL NOVA V5", UDim2.new(1, -85, 1, 0),
    UDim2.fromOffset(12, 0), 15)

local minimize = button(header, "−", UDim2.fromOffset(28, 27),
    UDim2.new(1, -65, 0, 8))

local close = button(header, "×", UDim2.fromOffset(28, 27),
    UDim2.new(1, -32, 0, 8))

-- Dragging (mouse and touch)

local dragging = false
local dragStart
local startPosition
local dragInput

track(header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end))

track(header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end))

track(UIS.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end))

-- Floating restore button

local restore = button(gui, "✦", UDim2.fromOffset(45, 45),
    UDim2.new(0, 15, 0.5, 0))
restore.Visible = false
corner(restore, 50)

track(minimize.Activated:Connect(function()
    main.Visible = false
    restore.Visible = true
end))

track(restore.Activated:Connect(function()
    main.Visible = true
    restore.Visible = false
end))

track(close.Activated:Connect(function()
    cleanup()
    gui:Destroy()
end))

-- Navigation

local nav = Instance.new("Frame")
nav.Position = UDim2.fromOffset(8, 51)
nav.Size = UDim2.new(1, -16, 0, 32)
nav.BackgroundTransparency = 1
nav.Parent = main

local homeTab = button(nav, "HOME", UDim2.new(1/3, -4, 1, 0),
    UDim2.fromOffset(0, 0))

local settingsTab = button(nav, "SETTINGS",
    UDim2.new(1/3, -4, 1, 0),
    UDim2.new(1/3, 2, 0, 0))

local historyTab = button(nav, "HISTORY",
    UDim2.new(1/3, -4, 1, 0),
    UDim2.new(2/3, 4, 0, 0))

-- Page container

local pages = Instance.new("Frame")
pages.Position = UDim2.fromOffset(9, 91)
pages.Size = UDim2.new(1, -18, 1, -101)
pages.BackgroundTransparency = 1
pages.Parent = main

local function newPage(name)
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = pages
    return p
end

local homePage = newPage("Home")
local settingsPage = newPage("Settings")
local historyPage = newPage("History")

homePage.Visible = true

-- Home page

label(homePage, "CAPTURE STATUS",
    UDim2.new(1, 0, 0, 22), UDim2.fromOffset(2, 0), 13)

local status = label(homePage, "● READY",
    UDim2.new(1, 0, 0, 25), UDim2.fromOffset(2, 22), 14)
status.TextColor3 = Color3.fromRGB(100, 240, 160)

label(homePage, "LATEST MESSAGE",
    UDim2.new(1, 0, 0, 20), UDim2.fromOffset(2, 56), 12)

local latest = Instance.new("TextLabel")
latest.Size = UDim2.new(1, -4, 0, 65)
latest.Position = UDim2.fromOffset(2, 78)
latest.BackgroundColor3 = PANEL
latest.TextColor3 = WHITE
latest.Text = "No messages captured yet."
latest.TextWrapped = true
latest.Font = Enum.Font.Gotham
latest.TextSize = 12
latest.Parent = homePage
corner(latest, 8)

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -4, 0, 38)
inputBox.Position = UDim2.fromOffset(2, 154)
inputBox.BackgroundColor3 = PANEL
inputBox.TextColor3 = WHITE
inputBox.PlaceholderColor3 = MUTED
inputBox.PlaceholderText = "Enter a test message..."
inputBox.Text = ""
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 12
inputBox.Parent = homePage
corner(inputBox, 8)

local captureButton = button(homePage, "TEST CAPTURE",
    UDim2.new(1, -4, 0, 36), UDim2.fromOffset(2, 202))

-- Settings

label(settingsPage, "CAPTURE SETTINGS",
    UDim2.new(1, 0, 0, 25), UDim2.fromOffset(2, 5), 15)

local captureEnabled = true
local duplicateEnabled = true

local captureToggle = button(settingsPage, "Capture: ON",
    UDim2.new(1, -4, 0, 38), UDim2.fromOffset(2, 45))

local duplicateToggle = button(settingsPage, "Duplicates: ON",
    UDim2.new(1, -4, 0, 38), UDim2.fromOffset(2, 92))

label(settingsPage, "Manual test mode only.",
    UDim2.new(1, -4, 0, 35), UDim2.fromOffset(2, 145), 12)

-- History

local historyTitle = label(historyPage, "CAPTURE HISTORY",
    UDim2.new(1, 0, 0, 25), UDim2.fromOffset(2, 0), 14)

local historyList = Instance.new("ScrollingFrame")
historyList.Size = UDim2.new(1, 0, 1, -30)
historyList.Position = UDim2.fromOffset(0, 30)
historyList.BackgroundColor3 = PANEL
historyList.BorderSizePixel = 0
historyList.ScrollBarThickness = 4
historyList.CanvasSize = UDim2.new()
historyList.AutomaticCanvasSize = Enum.AutomaticSize.Y
historyList.Parent = historyPage
corner(historyList, 8)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = historyList

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.Parent = historyList

-- Capture logic

local seen = {}
local history = {}
local historyCount = 0

local function capture(message)
    if not captureEnabled then
        status.Text = "● CAPTURE DISABLED"
        return
    end

    message = tostring(message):match("^%s*(.-)%s*$")

    if message == "" then
        status.Text = "● EMPTY MESSAGE"
        return
    end

    if duplicateEnabled and seen[message] then
        status.Text = "● DUPLICATE DETECTED"
        return
    end

    seen[message] = true
    latest.Text = message
    status.Text = "● CAPTURED"

    historyCount += 1

    local entry = {
        message = message,
        time = os.date("%H:%M:%S")
    }

    table.insert(history, 1, entry)

    local row = Instance.new("TextLabel")
    row.Size = UDim2.new(1, -4, 0, 48)
    row.BackgroundColor3 = DARK
    row.TextColor3 = WHITE
    row.Text = entry.time .. "  |  " .. message
    row.TextWrapped = true
    row.TextSize = 11
    row.Font = Enum.Font.Gotham
    row.LayoutOrder = -historyCount
    row.Parent = historyList
    corner(row, 6)

    while #history > 50 do
        local removed = table.remove(history)
        seen[removed.message] = nil

        local oldest = historyList:FindFirstChildWhichIsA("TextLabel")
        if oldest then
            oldest:Destroy()
        end
    end
end

track(captureButton.Activated:Connect(function()
    capture(inputBox.Text)
    inputBox.Text = ""
end))

track(captureToggle.Activated:Connect(function()
    captureEnabled = not captureEnabled
    captureToggle.Text = captureEnabled and "Capture: ON" or "Capture: OFF"
end))

track(duplicateToggle.Activated:Connect(function()
    duplicateEnabled = not duplicateEnabled
    duplicateToggle.Text = duplicateEnabled and "Duplicates: ON" or "Duplicates: OFF"
end))

-- Tab switching

local function showPage(page)
    homePage.Visible = page == homePage
    settingsPage.Visible = page == settingsPage
    historyPage.Visible = page == historyPage
end

track(homeTab.Activated:Connect(function()
    showPage(homePage)
end))

track(settingsTab.Activated:Connect(function()
    showPage(settingsPage)
end))

track(historyTab.Activated:Connect(function()
    showPage(historyPage)
end))

print("FULL NOVA V5 GUI loaded")

