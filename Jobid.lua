local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Server Info",
    LoadingTitle = "Server Info",
    LoadingSubtitle = "by Daniel"
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateButton({
    Name = "Job ID",
    Callback = function()
        local JobId = game.JobId

        Rayfield:Notify({
            Title = "Server Job ID",
            Content = JobId,
            Duration = 10,
            Image = 4483362458
        })

        print("Job ID:", JobId)
        setclipboard(JobId) -- Kopiert die Job-ID in die Zwischenablage (falls unterstützt)
    end
})