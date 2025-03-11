--[[
    This file is part of GeoJSON Loader 2.0.

    GeoJSON Loader 2.0 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    GeoJSON Loader 2.0 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with GeoJSON Loader 2.0. If not, see <https://www.gnu.org/licenses/>. ]]

lib = {
    STUD_CONVERT = 25 / 7, -- 1 meter converts to 3.571428 studs (or 25/7)
    SCALE_FACTOR = 637813, -- adjust this as needed
    R = 6371, -- radius of earth, KM
    FIRST_POINT = nil, -- The first point of the first feature. Assigned in loader. This will be spawned at, well, the origin. Other features will load around this (i.e. this is the center point)]]
}

--[[
    Project latitude and longitude to Cartesian coordinates. Formula used was obtained from @S1xty's GeoJSON Loader plugin. TODO: figure out the origin of this formula or make something actual unique (this should hopefully maybe preferably be temporary)
]]
function lib.Project(lat, long)
        local longitude, latitude = long - lib.FIRST_POINT[1], lat - lib.FIRST_POINT[2]

        local x = longitude*lib.SCALE_FACTOR*math.cos(math.rad(lat))
        local y = -latitude*lib.SCALE_FACTOR

	return x, y
end

--[[
    Distribute a selection of nodes between two points
]]
 function lib.Distribute(partsToDistribute : table, anchorOne, anchorTwo)
    --[[
        DISCLAIMER: I TAKE NO CREDIT FOR THE CREATION OF THIS PARTICULAR FUNCTION
        This function is a derivative of the free and open-source plugin found here:
        https://github.com/dytme/Distribute-Parts/tree/main, created by https://www.roblox.com/users/2487614411/profile
        all credit for this particular function goes to him. Any annotation added by me will be prefixed with [A]
    ]]

	if #partsToDistribute == 0 then return end

	local ActiveElements = {} -- Everything that can actually influence the plugin.. If you have invalid objects selected it won't error out this way.
	                          -- Will come in use later to check the distance between all selected objects. Kind of a work-around but this plugin was initially only for parts or meshes.
	for _,v in pairs(partsToDistribute) do
		table.insert(ActiveElements, {v, v.Position}) -- [A] As we know we will only be indexing regular, good ol Parts, we don't need to check the same way the original plugin did
	end

    local C1, C2 = anchorOne.Position, anchorTwo.Position -- Corner1 and Corner2 -- [A] We don't need to find the anchor points, as the anchor will always be the two nodes. I'm not sure the details of C1P or C2P so i'm keeping the function
	local C1P, C2P = anchorOne.Position, anchorTwo.Position -- Respective positions

	local Region = Region3.new(C1P, C2P)
	local RS = Region.Size
	local incX, incY, incZ = math.abs(RS.X) / (#ActiveElements - 1), math.abs(RS.Y) / (#ActiveElements - 1), math.abs(RS.Z) / (#ActiveElements - 1) -- Calculates the increments for all axis

	local xM, yM, zM = 1, 1, 1 -- Multipliers for all 3 axis

	if C1P.X > C2P.X then xM = -1 end
	if C1P.Y > C2P.Y then yM = -1 end
	if C1P.Z > C2P.Z then zM = -1 end

	local toMoveParts = {} -- Parts that will actually move
	for _,v in pairs(ActiveElements) do
		if v[1] ~= C1 and v[1] ~= C2 then
			table.insert(toMoveParts, v[1])
		end
	end

	-- Goes through all parts that actually move in the process
	for index,obj in pairs(toMoveParts) do

		-- Calculates new positions for all axis
		local X,Y,Z =
			C1P.X + index*incX*xM,
			C1P.Y + index*incY*yM,
			C1P.Z + index*incZ*zM

		obj:PivotTo(CFrame.new(X, Y, Z) * obj.CFrame.Rotation)
	end
end

--[[
    Gets the first point of the first feature. This should only be used during initialization, but I guess if you're too lazy to reference `lib.FIRST_POINT` it wouldnt hurt much?
]]
function lib:GetFirstPoint(features)
    print("Getting origin..")
    local coords = features[1].geometry.coordinates
    -- each type of geometry has a slightly different structure, we need to handle them seperately
    self.FIRST_POINT = if features[1].geometry.type == "Point" then {coords[1], coords[2]}
                        elseif features[1].geometry.type == "LineString" then {coords[1][1], coords[1][2]}
                        elseif features[1].geometry.type == "Polygon" then {coords[1][1][1], coords[1][1][2]}
                        else {coords[1][1][1][1], coords[1][1][1][2]}
end

function lib.draw3dTriangle(a, b, c, parent)

	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)

	if (abd > acd and abd > bcd) then
		c, a = a, c
	elseif (acd > bcd and acd > abd) then
		a, b = b, a
	end

	ab, ac, bc = b - a, c - a, c - b

	local right = ac:Cross(ab).unit
	local up = bc:Cross(right).unit
	local back = bc.unit

	local height = math.abs(ab:Dot(up))

    local model = Instance.new("Model")
    model.Parent = parent
    model.Name = "Triangle"

	local w1 = Instance.new("WedgePart")
	w1.Size = Vector3.new(0, height, math.abs(ab:Dot(back)))
	w1.CFrame = CFrame.fromMatrix((a + b)/2, right, up, back)
	w1.Parent = model

	local w2 = Instance.new("WedgePart")
	w2.Size = Vector3.new(0, height, math.abs(ac:Dot(back)))
	w2.CFrame = CFrame.fromMatrix((a + c)/2, -right, up, -back)
	w2.Parent = model

	return w1, w2
end
--[[
    TODO:
]]
function lib.MakeBaseplates()

end

-- no longer needed, keeping in case i need them again
--[[

    -- Gets the distance between two spherical coordinates using the Haversine formula
    function lib.GetLatLongDistance(lat1, long1, lat2, long2)
        local distanceLat = math.rad(lat2 - lat1)
        local distanceLong = math.rad(long2 - long1)

        -- thank you to https://www.movable-type.co.uk/scripts/latlong.html
        local a = math.sin(distanceLat/2) * math.sin(distanceLat/2) + math.cos(lat1) * math.cos(lat2) * math.sin(distanceLong/2) * math.sin(distanceLong/2) -- where `a` is the square of half the chord
        local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a)) -- angular distance

        local distance = lib.R * c
        return distance
    end


    -- Gets the bounding box of all features in a GeoJSON. This is slow as it has to check through every point in every feature and should only be used during initialization.

    function lib:GetBBox(geoJSON)
    print("Getting Boundary Box. This may take a moment...")
    local bounds = { -- we cant compare to nil, so this needs to be assigned. We can't assign them to zero because that would mean negative values wouldn't work properly. As such, we compare them to the origin
        xMin = lib.FIRST_POINT[1],
        xMax = lib.FIRST_POINT[1],
        yMin = lib.FIRST_POINT[2],
        yMax = lib.FIRST_POINT[2]
    }

    local coords, latitude, longitude

    for i, _ in geoJSON do
        coords = geoJSON[i].geometry.coordinates
        print("Checking coordinates for feature " .. i)

        if geoJSON[i].geometry.type == "Point" then
            longitude = coords[1]
            latitude = coords[2]
            bounds.xMin = if bounds.xMin < longitude then longitude else bounds.xMin
            bounds.xMax = if bounds.xMax > longitude then longitude else bounds.xMax
            bounds.yMin = if bounds.yMin < latitude then latitude else bounds.yMin
            bounds.yMax = if bounds.yMax > latitude then latitude else bounds.yMax
        else
            for v, j in coords[1] do
                if geoJSON[i].geometry.type == "MultiPolygon" then -- just like elsewhere, we need to handle MultiPolygons differently because they're special little boys (i hate this code)
                    local polygons = coords[v]
                    for k, _ in polygons do
                        longitude = polygons[k][1]
                        latitude = polygons[k][2]
                        bounds.xMin = if bounds.xMin < longitude then longitude else bounds.xMin
                        bounds.xMax = if bounds.xMax > longitude then longitude else bounds.xMax
                        bounds.yMin = if bounds.yMin < latitude then latitude else bounds.yMin
                        bounds.yMax = if bounds.yMax > latitude then latitude else bounds.yMax
                    end
                else
                    longitude = coords[j][1]
                    latitude = coords[j][2]
                    bounds.xMin = if bounds.xMin < longitude then longitude else bounds.xMin
                    bounds.xMax = if bounds.xMax > longitude then longitude else bounds.xMax
                    bounds.yMin = if bounds.yMin < latitude then latitude else bounds.yMin
                    bounds.yMax = if bounds.yMax > latitude then latitude else bounds.yMax
                end
            end
        end
    end

    self.BOUND_BOX = {
        xMin = bounds.xMin,
        xMax = bounds.xMax,
        yMin = bounds.yMin,
        yMax = bounds.yMax,
    }
    end
]]

return lib