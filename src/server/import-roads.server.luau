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
        {any}
   }
}
type GeoJsonInfo = {Feature}

---- CONSTANTS ----
local STUD_CONVERT = 25 / 7 -- studs to meters

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

-- gets the main key and value for the feature
function GetFeatureType(feature: Feature): (string, string)
    
    local key: string, value: string = nil, nil

    -- Determine the main feature type, or 'key'
    for _, featureType in FeatureTypes do
        if feature.properties[featureType.name] then
            key = featureType.name
        end
    end

    -- if no key has been found, then it is not implemented
    if key == nil then
        return "other", "other"
    end

    -- determine the secondary feature type, or 'value'
    for _, subtype in FeatureTypes[key] do
        if feature.properties[key] == subtype.name then
            value = subtype.name
        end
    end

    if value == nil then
        value = "other"
    end

    return key, value
end

function main()
    local GeoJsonInfo: GeoJsonInfo = LoadJsonFile()

    local folder = Instance.new("Folder")
    folder.Name = "Features"
    folder.Parent = workspace

    local FIRST_POINT = GetFirstPoint(GeoJsonInfo)

    -- the core loop, which iterates through each feature
    for i, feature in GeoJsonInfo do
        print(`Loading feature {i}`)

        -- skip features that arent a way
        if feature.geometry.type ~= "LineString" then
            print(`Feature {i} is not a way, skipping`)
            continue
        end

        local key, value = GetFeatureType(feature)

        local featureType = FeatureTypes[key][value]

        -- skip the feature if it is defined to not render or the main value is not defined
        if featureType.norender or key == "other" then
            continue
        end

        brickProperties = featureType.BrickProperties

        local points = feature.geometry.coordinates

        local location = Instance.new(folder)
        location.Parent = folder
        location.Name = "Feature" .. i

        local width = 
            if feature.properties.width then feature.properties.width * STUD_CONVERT
            elseif feature.properties.lanes then featureType.defaultWidth/2 * feature.properties.lanes
            elseif featureType.defaultWidth then featureType.defaultWidth
            else 5

        local height =
            if feature.properties.layer then feature.properties.layer * 10 * STUD_CONVERT
            elseif feature.properties.bridge then 10 * STUD_CONVERT
            elseif feature.properties.tunnel then -10 * STUD_CONVERT
            else 0

        
    end
end


Button.Click:Connect(main)
