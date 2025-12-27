local STUD_CONVERT = 25 / 7

return {
    highway = {
        motorway = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"), -- BrickColor of pavement, self explanatory
                Material = Enum.Material.Asphalt,
            }, -- Material to use
            defaultWidth = 11 * STUD_CONVERT, -- width, in meters, to be used if width not specified in data
            assumeOneWay = true, -- whether or not the road can be assumed to be oneway. not strictly necessary but might be useful considering how some roads are measured differently
            norender = false, -- if you don't want a feature to be rendered, add `norender=true` to its definition. explicitly setting it as false is not necessary, and is just here for example
            name = "motorway" -- for reasons, the name of the value needs to be stated seperately from its declaration. MANDATORY.
        },
        motorway_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 8 * STUD_CONVERT,
            assumeOneWay = true,
            name = "motorway_link"
        },
        trunk = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 10 * STUD_CONVERT,
            assumeOneWay = true,
            name = "trunk",
        },
        trunk_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 6.7 * STUD_CONVERT,
            assumeOneWay = true,
            name = "trunk_link"
        },
        primary = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 16 * STUD_CONVERT,
            name = "primary",
        },
        primary_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 6.3 * STUD_CONVERT,
            assumeOneWay = true,
            name = "primary_link",
        },
        secondary = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * STUD_CONVERT,
            name = "secondary",
        },
        secondary_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * STUD_CONVERT,
            assumeOneWay = true,
            name = "secondary_link",
        },
        tertiary = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * STUD_CONVERT,
            assumeOneWay = true,
            name = "tertiary",
        },
        tertiary_link = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * STUD_CONVERT,
            assumeOneWay = true,
            name = "tertiary_link",
        },
        unclassified = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * STUD_CONVERT,
            name = "unclassified",
        },
        residential = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * STUD_CONVERT,
            name = "residential",
        },
        living_street = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 7 * STUD_CONVERT,
            name = "living_street",
        },
        service = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 6 * STUD_CONVERT,
            name = "service",
        },
        pedestrian = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 4 * STUD_CONVERT,
            name = "pedestrian",
        },
        track = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 4 * STUD_CONVERT,
            name = "track"
        },
        footway = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 2 * STUD_CONVERT,
            name = "footway",
        },
        other = {
            norender = true,
            name = "other",
        },
        name = "highway"
    },
    barrier = {
        other = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Concrete,
            },
            name = "other",
        },
        name = "barrier",
    },
    railway = {
        platform = {
            BrickProperties = {
                BrickColor = BrickColor.new("Black"),
                Material = Enum.Material.Asphalt,
            },
            defaultWidth = 4 * STUD_CONVERT,
            name = "platform",
        },
        other = {
            BrickProperties = {
                BrickColor = BrickColor.new("Silver"),
                Material = Enum.Material.Metal,
            },
            defaultWidth = 1.435 * STUD_CONVERT, -- yes, this is guage. I'm calling it width so we dont need to handle this differently.
            name = "other",
        },
        name = "railway",
    },
    waterway = {
        river = {
            BrickProperties = {
                BrickColor = BrickColor.new("Earth blue"),
                Material = Enum.Material.Salt,
            },
            defaultWidth = 22 * STUD_CONVERT, -- rivers are huge
            name = "river",
        },
        stream = {
            BrickProperties = {
                BrickColor = BrickColor.new("Cyan"),
                Material = Enum.Material.Snow,
            },
            defaultWidth = 1.5 * STUD_CONVERT,
            name = "stream",
        },
        drain = {
            BrickProperties = {
                BrickColor = BrickColor.new("Cyan"),
                Material = Enum.Material.Snow,
            },
            defaultWidth = .5 * STUD_CONVERT,
            name = "drain",
        },
        ditch = {
            BrickProperties = {
                BrickColor = BrickColor.new("Cyan"),
                Material = Enum.Material.Snow,
            },
            defaultWidth = .5 * STUD_CONVERT,
            name = "ditch",
        },
        other = {
            norender = true,
            name = "other",
        },
        name = "waterway"
    },
}