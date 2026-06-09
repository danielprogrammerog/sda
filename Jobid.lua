local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Job ID Viewer",
    LoadingTitle = "Job ID Viewer",
    LoadingSubtitle = "by Daniel",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateButton({
    Name = "Job id",
    Callback = function()
        local jobId = game.JobId

        if setclipboard then
            setclipboard(jobId)
        end

        Rayfield:Notify({
            Title = "Job ID",
            Content = "Job ID wurde kopiert:\n" .. jobId,
            Duration = 6.5,
            Image = 4483362458
        })

        print("Job ID:", jobId)
    end
})