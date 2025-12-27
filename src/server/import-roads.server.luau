--!strict
---- SERVICES ----
local StudioService = game:GetService("StudioService")
local HttpService = game:GetService("HttpService")

---- TYPES ----
type GeoJsonInfo<T> = {any} -- generic type used for the table

---- MAIN ----

-- initialize plugin toolbar things
local Toolbar = plugin:CreateToolbar("GeoJSON Importer Early Access")
local Button = Toolbar:CreateButton("Click to select a file", "Import GeoJSON", "rbxassetid://12993969414") -- TODO: make a proper icon

-- Prompt the user to load a GeoJSON formatted file and return the features as a table
function LoadJsonFile<T>(): GeoJsonInfo<T>
    local file = StudioService:PromptImportFileAsync({"geojson", "json"}) :: File
    local data = file:GetBinaryContents()
    return HttpService:JSONDecode(data).features :: GeoJsonInfo<T>
end

function main()
    local GeoJsonInfo: GeoJsonInfo<any> = LoadJsonFile()


end


Button.Click:Connect(main)
