local lib = require(script.Parent.lib)
local material = Enum.Material
local triangulation = require(script.Parent.triangulation)
--[[
    Checks to see if feature properties match any described in the `polygons` dictionary.
    Will probably break if it has two "high level" tags (such as building AND landuse),
    so dont do that.
]]
local function matchProperties(feature)
    local properties = feature.properties
    local key, value

    -- i am not yanderedev :sob:
    if properties.natural then
        key = "natural"
    elseif properties.landuse then
        key = "landuse"
    elseif properties.amenity then
        key = "amenity"
    elseif properties.leisure then
        key = "leisure"
    elseif properties.railway then
        key = "railway"
    else key = "other" end


    if polygons[key] == nil then
        value = "other"
    elseif polygons[key][feature.properties[key]] then
        value = feature.properties[key]
    else
        value = "other"
    end
    return key, value
end

polygons = {
    natural = {
        grassland = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
            vegetation = {
                {
                    asset = "rbxassetid://1545393085", -- https://create.roblox.com/store/asset/6447246239/LowPoly-Grass
                    density = 0.9
                },
            },
        },
        heath = {
            brickProperties = {
                BrickColor = BrickColor.new("Burlap"),
                Material = material.Grass
            },
            vegetation = {
                {
                    asset = "rbxassetid://122954694956810", -- https://sketchfab.com/3d-models/low-poly-shrub-013144890fc24115937487781e8d3953 by @art_is_Scaryy
                    Size = Vector3.new(3.375, 1.736, 3.441),
                    BrickColor = BrickColor.new("Shamrock"),
                    density = 0.9,
                },
            },
        },
        scrub = { -- same as heath
            brickProperties = {
                BrickColor = BrickColor.new("Burlap"),
                Material = material.Grass
            },
            vegetation = {
                {
                    asset = "rbxassetid://122954694956810", -- https://sketchfab.com/3d-models/low-poly-shrub-013144890fc24115937487781e8d3953 by @art_is_Scaryy
                    Size = Vector3.new(3.375, 1.736, 3.441),
                    BrickColor = BrickColor.new("Shamrock"),
                    density = 0.9,
                },
            },
        },
        wood = {
            brickProperties = {
                BrickColor = BrickColor.new("Forest green"),
                Material = material.LeafyGrass
            },
            vegetation = {
                {
                    asset = "rbxassetid://10707210767", -- https://create.roblox.com/store/asset/10707210767/Low-Poly-Tree
                    Scale = 0.33,
                    density = 0.75,
                },
            },
        },
        bay = {
            brickProperties = {
                BrickColor = BrickColor.new("Electric blue"),
                Material = material.Snow
            },
        },
        beach = {
            brickProperties = {
                BrickColor = BrickColor.new("Wheat"),
                Material = material.Sand
            },
        },
        glacier = {
            brickProperties = {
                BrickColor = BrickColor.new("Pastel Blue"),
                Material = material.Ice
            },
        },
        mud = {
            brickProperties = {
                BrickColor = BrickColor.new("Pine Cone"),
                Material = material.Mud
            },
        },
        shingle = {
            brickProperties = {
                BrickColor = BrickColor.new("Dark stone grey"),
                Material = material.Asphalt
            },
        },
        shoal = {
            brickProperties = {
                BrickColor = BrickColor.new("Wheat"),
                Material = material.Sand
            },
        },
        strait = {
            brickProperties = {
                BrickColor = BrickColor.new("Electric blue"),
                Material = material.Snow
            },
        },
        water = {
            brickProperties = {
                BrickColor = BrickColor.new("Electric blue"),
                Material = material.Snow
            },
        },
        bare_rock = {
            brickProperties = {
                BrickColor = BrickColor.new("Dark stone grey"),
                Material = material.Rock
            },
        },
        sand = {
            brickProperties = {
                BrickColor = BrickColor.new("Wheat"),
                Material = material.Sand
            },
        },
        scree = {
            brickProperties = {
                BrickColor = BrickColor.new("Dark stone grey"),
                Material = material.Asphalt
            },
        },
        other = {
            norender = true
        }

    },
    landuse = {
        commercial = {
            brickProperties = {
                BrickColor = BrickColor.new("Mid gray"),
                Material = material.Concrete
            },
        },
        construction = {
            brickProperties = {
                BrickColor = BrickColor.new("Fawn brown"),
                Material = material.Ground
            },
        },
        industrial = {
            brickProperties = {
                BrickColor = BrickColor.new("Mid gray"),
                Material = material.Concrete
            },
        },
        residential = {
            brickProperties = {
                BrickColor = BrickColor.new("Shamrock"),
                Material = material.Grass,
            },
        },
        retail = {
            brickProperties = {
                BrickColor = BrickColor.new("Mid gray"),
                Material = material.Concrete
            },
        },
        farmland = {
            brickProperties = {
                BrickColor = BrickColor.new("Pine Cone"),
                Material = material.Ground
            },
            vegetation = {
                {
                    asset = "rbxassetid://5238847492", -- https://create.roblox.com/store/asset/5238852456/Field-of-Wheat
                    TextureID = "rbxassetid://5238847755",
                    Scale = Vector3.new(7.354, 4.504, 7.354),
                    doNotRotate = true,
                    density = 1,
                },
            },
        },
        farmyard = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
        },
        forest = { -- same as `natural=wood`
            brickProperties = {
                BrickColor = BrickColor.new("Forest green"),
                Material = material.LeafyGrass
            },
            vegetation = {
                {
                    asset = "rbxassetid://10707210767", -- https://create.roblox.com/store/asset/10707210767/Low-Poly-Tree
                    Scale = 0.33,
                    density = 0.75,
                },
            },
        },
        meadow = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
            vegetation = {
                {
                    asset = "rbxassetid://1545393085", -- https://create.roblox.com/store/asset/6447246239/LowPoly-Grass
                    density = 0.6,
                },
                {
                    asset = "rbxassetid://122954694956810", -- https://sketchfab.com/3d-models/low-poly-shrub-013144890fc24115937487781e8d3953 by @art_is_Scaryy
                    Size = Vector3.new(3.375, 1.736, 3.441),
                    BrickColor = BrickColor.new("Shamrock"),
                    density = 0.2,
                },
            },
        },
        orchard = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
            vegetation = {
                {
                    asset = "rbxassetid://10707210767", -- https://create.roblox.com/store/asset/10707210767/Low-Poly-Tree
                    Scale = 0.33,
                    density = 0.75,
                    doNotRotate = true,
                },
            },
        },
        vineyard = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
            -- TODO: Find a good asset for this
        },
        basin = {
            brickProperties = {
                BrickColor = BrickColor.new("Electric blue"),
                Material = material.Snow
            },
        },
        salt_pond = {
            brickProperties = {
                BrickColor = BrickColor.new("Electric blue"),
                Material = material.Snow
            },
        },
        brownfield = {
            brickProperties = {
                BrickColor = BrickColor.new("Fawn brown"),
                Material = material.Ground
            },
        },
        cemetery = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
            -- TODO: Find a good asset for this
        },
        grass = { -- same as grassland for now
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
            vegetation = {
                {
                    asset = "rbxassetid://1545393085", -- https://create.roblox.com/store/asset/6447246239/LowPoly-Grass
                    density = 0.9
                },
            },
        },
        landfill = {
            brickProperties = {
                BrickColor = BrickColor.new("Fawn brown"),
                Material = material.Ground
            },
        },
        quarry = {
            brickProperties = {
                BrickColor = BrickColor.new("Medium stone grey"),
                Material = material.Ground
            },
        },
        railway = {
            brickProperties = {
                BrickColor = BrickColor.new("Medium stone grey"),
                Material = material.Asphalt
            },
        },
        religious = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
        },
        other = {
            norender = true
        }
    },
    amenity = {
        parking = {
           brickProperties = {
            BrickColor = BrickColor.new("Black"), -- BrickColor of pavement, self explanatory
            Material = Enum.Material.Asphalt,
            },
        },
        school = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
        },
        other = {
            norender = true
        }
    },
    leisure = {
        garden = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
            vegetation = {
                {
                    asset = "rbxassetid://122954694956810", -- https://sketchfab.com/3d-models/low-poly-shrub-013144890fc24115937487781e8d3953 by @art_is_Scaryy
                    Size = Vector3.new(3.375, 1.736, 3.441),
                    BrickColor = BrickColor.new("Shamrock"),
                    density = 0.9,
                },
            },
        },
        park = {
            brickProperties = {
                BrickColor = BrickColor.new("Camo"),
                Material = material.Grass,
            },
        },
        swimming_pool = {
            water = {
                brickProperties = {
                    BrickColor = BrickColor.new("Electric blue"),
                    Material = material.Snow
                },
            },
        },
        other = {
            norender = true
        }
    },
    railway = {
        platform = {
            brickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
        },
        other = {
            norender = true
        }
    },
}

function polygons.Main(feature, n)
    local key, value = matchProperties(feature)

    if key == "other" or polygons[key][value] == nil then return end -- dont continue if a feature isnt defined

    local location = Instance.new("Folder")
    location.Parent = workspace.Features
    location.Name = "Feature" .. n

    local points = feature.geometry.coordinates[1]
    local vertices = {}
    local brickProperties = polygons[key][value].brickProperties

    -- this will give us a table of every point

    for i, point in points do
         -- convert longitude and latitude into coordinates we can reasonably use on roblox
         local xPoint, yPoint = lib.Project(point[2], point[1])

         -- plot each "point" onto the map. This is optional, but helps to visualize. I'm keeping it here for debugging purposes
        local part = Instance.new("Part", location)
        part.Name = "point" .. i
        part.Position = Vector3.new(xPoint, 0.1, yPoint)
        part.Size = Vector3.new(1, 1, 1)

        vertices[i] = Vector3.new(xPoint, 0.1, yPoint)
        -- add each point into a table. We need this for triangulation
    end

    lib.draw3dTriangle()

    --[[if feature.properties.building then -- handle buildings seperately because they have many different properties and features than other polygons
        -- TODO:
        return
    else
        triangulation.Perform(vertices, true)
    end]]
end

return polygons