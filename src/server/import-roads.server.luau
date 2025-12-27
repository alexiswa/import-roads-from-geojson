---- SERVICES ----
local StudioService = game:GetService("StudioService")
local HttpService = game:GetService("HttpService")

---- MODULES ----
local FeatureTypes = require("FeatureTypes.luau")

---- TYPES ----
type Feature = {
   ["geometry"]: {
        ["coordinates"]: 
            {any},
        ["type"]: string
   },
   ["properties"]: {
        {key: string}
   }
}
type GeoJsonInfo = {Feature}

---- MAIN ----

-- initialize plugin toolbar things
local Toolbar = plugin:CreateToolbar("GeoJSON Importer Early Access")
local Button = Toolbar:CreateButton("Click to select a file", "Import GeoJSON", "rbxassetid://12993969414") -- TODO: make a proper icon

-- Prompt the user to load a GeoJSON formatted file and return the features as a table
function LoadJsonFile(): GeoJsonInfo
    local file = StudioService:PromptImportFileAsync({"geojson", "json"}) :: File
    local data = file:GetBinaryContents()
    return HttpService:JSONDecode(data).features :: GeoJsonInfo
end

function GetFirstPoint(features: GeoJsonInfo)
    print("Getting origin..")
    local coords = features[1].geometry.coordinates
    -- each type of geometry has a slightly different structure, we need to handle them seperately
    return if features[1].geometry.type == "Point" then {coords[1], coords[2]}
                        elseif features[1].geometry.type == "LineString" then {coords[1][1], coords[1][2]}
                        elseif features[1].geometry.type == "Polygon" then {coords[1][1][1], coords[1][1][2]}
                        else {coords[1][1][1][1], coords[1][1][1][2]}
end
function main()
    local GeoJsonInfo: GeoJsonInfo = LoadJsonFile()


end


Button.Click:Connect(main)
