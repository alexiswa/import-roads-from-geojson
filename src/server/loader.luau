--[[     
    This file is part of GeoJSON Loader 2.0.

    GeoJSON Loader 2.0 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    GeoJSON Loader 2.0 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with GeoJSON Loader 2.0. If not, see <https://www.gnu.org/licenses/>. ]]

local StudioService = game:GetService("StudioService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local plugin = script.Parent
local ways = require(plugin.ways)
local polygons = require(plugin.polygons)
local lib = require(plugin.lib)

loader = {}

function loader.main()
    local file = StudioService:PromptImportFile({"geojson", "json"})
    local data = file:GetBinaryContents()
    local Features = HttpService:JSONDecode(data).features
    local folder = Instance.new("Folder", Workspace)
    folder.Name = "Features"
    local plates = Instance.new("Folder", folder)
    plates.Name = "Plates"
    -- call functions to assign constants that need to read data before assignment
    lib:GetFirstPoint(Features)

    for i, feature in Features do
        print(`loading feature {i}`)

        -- the primary purpose of this is just to figure out what kind of geometry a given feature has, and then call
        -- the appropriate functions for said geometry. Most processing happens elsewhere.
        if feature.properties == nil then
            -- necessary for reasons beyond my understanding. Warn statement is not actually necessary but may as well have it i guess?
            warn(`Feature {i} is untagged, skipping..`)
        elseif feature.geometry.type == "LineString" then
            local succ, err = pcall(function()
                ways.Main(feature, i)
            end)
            if err then
                warn(`Error loading feature {i}, skipping. \n\t\t\t\t Error: {err}`) -- setting this to error while im making it
            end
        elseif feature.geometry.type == "Polygon" then
            local succ, err = pcall(function()
                polygons.Main(feature, i)
            end)
            if err then
                warn(`Error loading feature {i}, skipping. \n\t\t\t\t Error: {err}`) -- setting this to error while im making it
            end
        elseif feature.geometry.type == "MultiPolygon" then
            -- TODO
        else
            warn(`Feature {i} has unknown geomtry type {feature.geometry.type}, skipping`)
        end
    end

    print("Done!")
end

return loader