local HttpService = game:GetService("HttpService")
--[[
    This file is part of GeoJSON Loader 2.0.

    GeoJSON Loader 2.0 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    GeoJSON Loader 2.0 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with GeoJSON Loader 2.0. If not, see <https://www.gnu.org/licenses/>. ]]

local lib = require(script.Parent.lib)
local studConvert = lib.STUD_CONVERT

-- I LOVE MODULARITY! I LOVE BEING ABLE TO ADD NEW FEATURES WITH MINIMUM CHANGES!!!!
--[[
A table of all ways that are compatable with the plugin. If you want to add your own, you should be able to relatively easily.
Currently supports most highway features, some waterway features, and has generic attributes for rail and barrier features.
Make sure that, when you add a feature, it is a 2-dimensional way. This includes highways, power lines, et cetera. for areas/polygons and multipolygons,
you should go to their respective areas. I would highly recommend collapsing this if you're going to be working on the actual functions in this script
]]
ways = {
    highway = {
        motorway = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"), -- BrickColor of pavement, self explanatory
                Material = Enum.Material.Asphalt,
            }, -- Material to use
            defaultWidth = 11 * studConvert, -- width, in meters, to be used if width not specified in data
            assumeOneWay = true, -- whether or not the road can be assumed to be oneway. not strictly necessary but might be useful considering how some roads are measured differently
            norender = false -- if you don't want a feature to be rendered, add `norender=true` to its definition. explicitly setting it as false is not necessary, and is just here for example
        },
        motorway_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 8 * studConvert,
            assumeOneWay = true
        },
        trunk = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 10 * studConvert,
            assumeOneWay = true
        },
        trunk_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 6.7 * studConvert,
            assumeOneWay = true
        },
        primary = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 16 * studConvert,
        },
        primary_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 6.3 * studConvert,
            assumeOneWay = true
        },
        secondary = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * studConvert,
        },
        secondary_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * studConvert,
            assumeOneWay = true
        },
        tertiary = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * studConvert,
            assumeOneWay = true
        },
        tertiary_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * studConvert,
            assumeOneWay = true
        },
        unclassified = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * studConvert,
        },
        residential = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * studConvert,
        },
        living_street = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * studConvert,
        },
        service = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 6 * studConvert,
        },
        pedestrian = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 4 * studConvert,
        },
        track = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 4 * studConvert,
        },
        footway = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 2 * studConvert,
        },
        other = {
            norender = true
        },
    },
    barrier = {
        other = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Concrete,
            },
        },
    },
    railway = {
        platform = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 4 * studConvert,
        },
        other = {
            BrickProperties = {
                BrickColor = BrickColor.new("Silver"),
                Material = Enum.Material.Metal,
            },
            defaultWidth = 1.435 * studConvert -- yes, this is guage. I'm calling it width so we dont need to handle this differently.
        }
    },
    waterway = {
        river = {
            BrickProperties = {
                BrickColor = BrickColor.new("Earth blue"),
                Material = Enum.Material.Salt,
            },
            defaultWidth = 22 * studConvert, -- rivers are huge
        },
        stream = {
            BrickProperties = {
                BrickColor = BrickColor.new("Cyan"),
                Material = Enum.Material.Snow,
            },
            defaultWidth = 1.5 * studConvert,
        },
        drain = {
            BrickProperties = {
                BrickColor = BrickColor.new("Cyan"),
                Material = Enum.Material.Snow,
            },
            defaultWidth = .5 * studConvert,
        },
        ditch = {
            BrickProperties = {
                BrickColor = BrickColor.new("Cyan"),
                Material = Enum.Material.Snow,
            },
            defaultWidth = .5 * studConvert,
        },
        other = {
            norender = true
        }

    },
}


-- TODO: Split the actual rendering into a new function so i can reuse this when rendering polygons
--[[
Main function for processing ways
]]
function ways.Main(feature, i)
    local key, value = ways.matchProperties(feature)
    local brickProperties
    
    if key == "other" or ways[key][value] == nil then return end -- dont continue if a feature isnt defined

    brickProperties = ways[key][value].BrickProperties
    

    local points = feature.geometry.coordinates
    
    local location = Instance.new("Folder")
    location.Parent = workspace.Features
    location.Name = "Feature" .. i

    local width =
        if feature.properties.width then feature.properties.width * lib.STUD_CONVERT
        elseif feature.properties.lanes then (ways[key][value].defaultWidth/2) * feature.properties.lanes
        elseif ways[key][value].defaultWidth then ways[key][value].defaultWidth
        else 5


    for point, _ in points do
        -- convert longitude and latitude into coordinates we can reasonably use on roblox
        local x, z = lib.Project(points[point][2], points[point][1])

        -- plot each "point" onto the map
        local part = Instance.new("Part", location)
        part.Name = "point" .. point
        part.Position = Vector3.new(x, 0.6, z)
        part.Size = Vector3.new(1, 1, 1)

        if point >= 2 then
            ways.Draw(location["point"..point - 1], location["point"..point], location, point)
        end
    end

    -- Sort through everything in the feature's folder
    for _, j in location:GetChildren() do
        if string.match(j.Name, ("Link")) then -- if its a link connecting two nodes, assign its properties
            j.Size = Vector3.new(width, j.Size.Y, j.Size.Z) -- assign width
            if brickProperties ~= nil then
                for p, property in brickProperties do
                    j[p] = property
                end
            end
        elseif string.match(j.Name, "point") then -- if its a node, delete it
            j:Destroy()
        elseif string.match(j.Name, "extraNodes") then -- if its the folder made for intermediary points between long distances, delete the other points and itself
            for _, k in j:GetChildren() do
                k:Destroy()
            end
            j:Destroy()
        end
    end
end


--[[
    Draw a line between two points.
]]
function ways.Draw(pointOne, pointTwo, location, i)
    local magnitude = (pointOne.Position - pointTwo.Position).Magnitude
    local midPoint = (pointOne.Position + pointTwo.Position)/2

    if magnitude >= 2048 then -- max part length of 2048, if its over this length we need to split it into smaller parts and handle it seperately
        warn(`Warning! Feature {i} has a segment longer than 2048 studs! Maximum length: 2048, segment length: {magnitude}`)

        local magnitudeCheck = magnitude
        local i = 0
        local partsToCheck = {}
        local links = {}
        local extraNodes = Instance.new("Folder", location)
        extraNodes.Name = "extraNodes" .. HttpService:GenerateGUID(false)
    
        while magnitudeCheck >= 2048 do -- determine how many parts we need
            magnitudeCheck /= 2
            i += 10
            task.wait()
        end

        for j = 1, i do -- make `i` points
            local newNode = Instance.new("Part", extraNodes)
            newNode.Name = "IntermediateNode" .. j
            newNode.Position = midPoint
            table.insert(partsToCheck, newNode)
        end
        lib.Distribute(partsToCheck, pointOne, pointTwo) -- distribute previously made points between the two original points

        for l, _ in extraNodes:GetChildren() do -- this segment does essentially the same thing as it would if the magnitude werent > 2048. It just iterates over the intermediate nodes instead of the actual nodes. This is to get around roblox's part size limit.

            -- if l = 0, then keep pointOne the same. otherwise, set it to the previous point.
            local newPointOne = if l == 1 then pointOne else
                extraNodes["IntermediateNode" .. l-1]

            local newPointTwo = if l >= (#extraNodes:GetChildren() - 1) then pointTwo else
                extraNodes["IntermediateNode" .. l]

            local magnitude = (newPointOne.Position - newPointTwo.Position).Magnitude
            local midPoint = (newPointOne.Position + newPointTwo.Position)/2

            if magnitude > 2048 then -- if something has been divided into this many segments and it still has gaps, frankly its not my problem anymore.
                warn(`Feature has a VERY long segment! Gaps are likely to occur. Attempting to render.. `)
            end

            local link = Instance.new("Part", location)
            link.CFrame = CFrame.new(newPointOne.Position, newPointTwo.Position) -- CFrame.new(pos, lookAt). This means that the position will be at point one, and it will be rotated to point towards point two
            link.Name = "Link".. l - 1
            link.Size = Vector3.new(1, 1, magnitude)
            link.Position = midPoint

            table.insert(links, link)
        end

        return links
    else
        local link = Instance.new("Part", location)
        link.CFrame = CFrame.new(pointOne.Position, pointTwo.Position) -- CFrame.new(pos, lookAt). This means that the position will be at point one, and it will be rotated to point towards point two
        link.Name = "Link".. i - 1
        link.Size = Vector3.new(2, 1, magnitude)
        link.Position = midPoint

        return link
    end
end

--[[
    Checks to see if feature properties match any described in the `ways` table.
    Will probably break if it has two "high level" tags (such as railway AND highway),
    so dont do that.
]]
function ways.matchProperties(feature)
    local properties = feature.properties
    local key, value

    -- i am not yanderedev :sob:
    if properties.highway then
        key = "highway"
    elseif properties.railway then
        key = "railway"
    elseif properties.waterway then
        key = "waterway"
    elseif properties.barrier then
        key = "barrier"
    else
        key = "other"
    end

    if ways[key] == nil then -- you cant check ways[key][feature.properties[key]] if ways[key] is null, so if ways[key] is null, assign value as "other"
        value = "other"
    elseif ways[key][feature.properties[key]] then
        value = feature.properties[key]
    else
        value = "other"
    end
    return key, value
end

return ways