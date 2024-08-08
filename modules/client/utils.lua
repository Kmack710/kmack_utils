--- Utils used in modules, put here so its easier for people to edit/change them
local Utils = {}
local Bridge = exports.kmack_bridge:GetBridge()
function Utils.SkillBarMinigame(diff, isAdv)
    local rounds = 2 --- easy values
    local time = 5000
    local width = 10
    if diff == 'medium' then
        rounds = 3
        time = 4000
    elseif diff == 'hard' then
        rounds = 4
        time = 3000
    end
    if isAdv then
        rounds = 1
        time = 3000
        width = 15
    end
    return exports['SN-Hacking']:SkillBar(time, width, rounds)

end

function Utils.HotWireMinigame(diff, isAdv)
    local time = 5000
    local rounds = 2
    if diff == 'easy' then
        rounds = 1
    elseif diff == 'medium' then
        rounds = 2
        time = 4000
    elseif diff == 'hard' then
        rounds = 3
        time = 3000
    end
    return exports['SN-Hacking']:SkillCheck(50, time, {'w','a','s','d'}, rounds, 20, 3)
end






return Utils