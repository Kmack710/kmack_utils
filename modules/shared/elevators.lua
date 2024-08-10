local Elevators = {
    [1] = {
        floors = {
            [1] = {
                coords = vec4(451.8831, -975.4421, 31.0262, 5.5261), --- if using target option
                exitCoords = vec4(450.2600, -973.9681, 30.5, 176.2863), --- where the ped will exit the elevator
                label = 'Ground Floor',
                jobRestricted = {'police', 'sheriff'}, -- or false for no job lock this is done per floor
                zone = { -- if using radial menu
                    vec3(454.3696, -972.6551, 31),
                    vec3(454.3130, -976.9051, 31),
                    vec3(449.0277, -976.9203, 31),
                    vec3(449.3098, -972.7225, 31)
                }
            },
            [2] = {
                coords = vec4(451.8339, -975.5280, 35.7980, 0.6372),
                exitCoords = vec4(450.0921, -973.6003, 35.2979, 188.9752),
                label = '2nd Floor',
                jobRestricted = {'police', 'sheriff'}, -- or false for no job lock this is done per floor
                zone = {
                    vec3(449.2905, -972.7548, 36),
                    vec3(449.1124, -977.1506, 36),
                    vec3(454.6466, -976.9542, 36),
                    vec3(454.3343, -972.7671, 36)
                }
            }
        }
    }
}

return Elevators