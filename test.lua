local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/EncryptedV5/Library/refs/heads/main/Library.lua')))()

local MyLibrary = Library:AddWindow("My Cool UI")

local MainTab = MyLibrary:AddTab("Main")

MainTab:AddLabel({
    Name = "Welcome to the UI!"
})

MainTab:AddTextbox({
    Default = "Type here...",
    TextDisappear = true,
    Callback = function(text)
        print("Textbox entered:", text)
    end
})

MainTab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(state)
        print("Toggle is now:", state)
    end
})

MainTab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button was clicked!")
    end
})

MainTab:AddDropdown({
    Default = "Select an Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Callback = function(option)
        print("You selected:", option)
    end
})
