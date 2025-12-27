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
local SCALE_FACTOR = 637813 -- adjust this as needed, arbitrary coefficient for map projection

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

-- Gets the first point of the first feature for initialization purposes
function GetFirstPoint(features: GeoJsonInfo)
    print("Getting origin..")
    local coords = features[1].geometry.coordinates
    -- each type of geometry has a slightly different structure, we need to handle them seperately
    return if features[1].geometry.type == "Point" then {coords[1], coords[2]}
                        elseif features[1].geometry.type == "LineString" then {coords[1][1], coords[1][2]}
                        elseif features[1].geometry.type == "Polygon" then {coords[1][1][1], coords[1][1][2]}
                        else {coords[1][1][1][1], coords[1][1][1][2]}
end

-- projects the spherical coordinates of a feature onto a 2d plane
function Project(lat, long, FIRST_POINT)
    -- make everything in reference to the first point
    local longitude, latitude = long - FIRST_POINT[1], lat - FIRST_POINT[2]

    -- flatten sphere to plane
    local x = longitude * SCALE_FACTOR * math.cos(math.rad(lat))
    local y = -latitude * SCALE_FACTOR

	return x, y
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

-- divide the distance between two points in half, for long ways
function DivideMidpoints(p1, p2, width, height): {Vector3}
    local midpoint = (p1 + p2) / 2
	
    local newMidpoints: {Vector3} = {midpoint}

    -- recursively divide them again if its still too long
    if (midpoint - p1).magnitude >= 2048 then
        -- add the new point to the start of the table
        table.insert(newMidpoints, 1, DivideMidpoints(midpoint, p1))
    end

    if (midpoint - p2).magnitude >= 2048 then
        -- add the new point to the end of the table
        table.insert(newMidpoints, DivideMidpoints(midpoint, p2))
    end

    return newMidpoints
end

function ConnectPoints(point: number, pointVectors: {Vector3}, width: number)

    local p1 = pointVectors[point - 1]
    local p2 = pointVectors[point]

    local magnitude = (p1 - p2).magnitude
    local midpoint = (p1 + p2)/2

    -- if the magnitude is greater than 2048, it needs to be split into several smaller parts due to the roblox part size limit
    if magnitude >= 2048 then
        local newPoints = DivideMidpoints(p1, p2)

        for i, point in newPoints do
            if i == 1 then
                -- make a part between the two points
                local link: Part = Instance.new("Part")
                link.CFrame = CFrame.new(p1, newPoints[i+1]) -- pos, lookat
                link.Name = "midlink " .. i - 1
                ink.Size = Vector3.new(width, 1, magnitude)
                link.Position = point
            elseif i == #newPoints then
                -- make a part between the two points
                local link: Part = Instance.new("Part")
                link.CFrame = CFrame.new(newPoints[i-1], p2) -- pos, lookat
                link.Name = "midlink " .. i - 1
                link.Size = Vector3.new(width, 1, magnitude)
                link.Position = point
            else
                -- make a part between the two points
                local link: Part = Instance.new("Part")
                link.CFrame = CFrame.new(newPoints[i-1], newPoints[i+1]) -- pos, lookat
                link.Name = "midlink " .. i - 1
                link.Size = Vector3.new(width, 1, magnitude)
                link.Position = point
            end
        end
    end

    -- make a part between the two points
    local link: Part = Instance.new("Part")
    link.CFrame = CFrame.new(p1, p2) -- pos, lookat
    link.Name = "link " .. point - 1
    link.Size = Vector3.new(width, 1, magnitude)
    link.Position = midpoint
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

        local brickProperties = featureType.BrickProperties

        local points = feature.geometry.coordinates

        local location = Instance.new(folder)
        location.Parent = folder
        location.Name = "Feature" .. i

        -- set width based on lane properties and tags
        local width = 
            if feature.properties.width then feature.properties.width * STUD_CONVERT
            elseif feature.properties.lanes then featureType.defaultWidth/2 * feature.properties.lanes
            elseif featureType.defaultWidth then featureType.defaultWidth
            else 5

        -- set height based on layer property and tunnel/bridge properties
        local height =
            if feature.properties.layer then feature.properties.layer * 10 * STUD_CONVERT
            elseif feature.properties.bridge then 10 * STUD_CONVERT
            elseif feature.properties.tunnel then -10 * STUD_CONVERT
            else 0


        local pointsAsVectors: {Vector3} = {}
        
        for point, _ in points do
            -- convert longitude and latitude into x and z
            local x, z = Project(points[point][2], points[point][1], FIRST_POINT)
            -- add it to the table of vector points, with the height being calculated above
            table.insert(pointsAsVectors, Vector3.new(x, height, z))

            -- connect each point
            if point >= 2 then
                ConnectPoints(point, pointsAsVectors, width)
            end
        end

        for _, i in location do
            -- check if theres any properties to be assigned
            if not string.match(i.name, "link") and brickProperties == nil then
                continue
            end

            -- assign properties
            for p, property in brickProperties do
                i[p] = property
            end
        end
    end
end


Button.Click:Connect(main)