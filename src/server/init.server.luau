--[[
    I hereby disclaims all copyright interest in the program "GeoJSON Loader 2.0" (Which automatically imports GeoJSON files into Roblox Studio)
    Copyright (C) tahadagal

    ~ Alexis W., known as 'SUBLIMATlON', reachable as 'tahadagal', full name withheld for privacy. Contact info is available on the GitHub page, [link github here]

    This file is part of GeoJSON Loader 2.0.

    GeoJSON Loader 2.0 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    GeoJSON Loader 2.0 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with GeoJSON Loader 2.0. If not, see <https://www.gnu.org/licenses/>. ]]

--[[
    Made by tahadagal/SUBLIMATlON

    inspired by S1xty's GeoJSON City Loader plugin, which I have used several times as a reference.
    Found here: https://create.roblox.com/store/asset/6401373072/GeoJSON-City-Loader

    I tried to document this the best I could, because its a fairly complicated process,
    and I myself don't fully understand all the math behind it. I'm also a firm believer
    in FOSS, including peoples ability to modify programs to fit their own needs. Feel
    free to modify and/or edit this as needed without permission, all I request is
    proper attribution. Do not upload derivatives as paid access, this violates GPL and I will DMCA.

    This was made to be as modular as possible so hopefully it is

    shoutouts:
        diamantschiff (not on roblox) for telling me about S1xty's plugin
        the OGF community, which gave me a practical reason to create this
    
    attribution:
            dytme's plugin for distributing points, https://github.com/dytme/Distribute-Parts/tree/main
            Chaotic Cody's https://github.com/Chaotic-Cody/polyhedron/tree/master, specifically src/ReplicatedStorage/TriangleModule.lua, which I use for filling polygons
            S1xty for creating the plugin that inspired this, and the formula used to project longitude and latitude onto roblox coordinates which I got from his plugin.

        models:
            https://sketchfab.com/3d-models/low-poly-shrub-013144890fc24115937487781e8d3953 by @art_is_Scaryy
            https://create.roblox.com/store/asset/10707210767/Low-Poly-Tree?viewFromStudio=true&keyword=low%20poly%20tree&searchId=4f2e8ace-180b-464c-931c-25c56d42ba5d by @z4cked on Roblox

    made and formatted with rojo in mind, shouldnt be too different for studio users though.

    TODO:
        actually render stuff lol
        relation (multipolygon) support
        some other stuff im forgetting
        github???

________________________________________________________________________________________________________]]

local Toolbar = plugin:CreateToolbar("GeoJSON Importer 2.0")
local Button = Toolbar:CreateButton("Click to select a file", "Import GeoJSON", "rbxassetid://12993969414") -- TODO: make a proper icon

local loader = require(script.loader)

Button.Click:Connect(loader.main)