local monsters = {
    dependencies = { "list", "dictionary" }
}

function monsters:init()
end

function monsters:getMonsterObject(idMonster)
    local data = d2data:objectFromD2O("Monsters", idMonster)

    if data then
        data = data.Fields
        local parseGrade = function(grades)
            local parseBonusCharacteristics = function(bonusCharacteristics)
                return {
                    lifePoints = bonusCharacteristics.lifePoints,
                    strenght = bonusCharacteristics.strenght,
                    wisdom = bonusCharacteristics.wisdom,
                    chance = bonusCharacteristics.chance,
                    agility = bonusCharacteristics.agility,
                    intelligence = bonusCharacteristics.intelligence,
                    earthResistance = bonusCharacteristics.earthResistance,
                    fireResistance = bonusCharacteristics.fireResistance,
                    waterResistance = bonusCharacteristics.waterResistance,
                    airResistance = bonusCharacteristics.airResistance,
                    neutralResistance = bonusCharacteristics.neutralResistance,
                    tackleEvade = bonusCharacteristics.tackleEvade,
                    tackleBlock = bonusCharacteristics.tackleBlock,
                    bonusEarthDamage = bonusCharacteristics.bonusEarthDamage,
                    bonusFireDamage = bonusCharacteristics.bonusFireDamage,
                    bonusWaterDamage = bonusCharacteristics.bonusWaterDamage,
                    bonusAirDamage = bonusCharacteristics.bonusAirDamage,
                    APRemoval = bonusCharacteristics.APRemoval
                }
            end

            local ret = self.dictionary()

            for _, v in pairs(grades) do
                ret:add(v.Fields.grade,
                    {
                        monsterId = v.Fields.monsterId,
                        level = v.Fields.level,
                        lifePoints = v.Fields.lifePoints,
                        actionPoints = v.Fields.actionPoints,
                        movementPoints = v.Fields.movementPoints,
                        vitality = v.Fields.vitality,
                        paDodge = v.Fields.paDodge,
                        pmDodge = v.Fields.pmDodge,
                        earthResistance = v.Fields.earthResistance,
                        airResistance = v.Fields.airResistance,
                        fireResistance = v.Fields.fireResistance,
                        waterResistance = v.Fields.waterResistance,
                        neutralResistance = v.Fields.neutralResistance,
                        gradeXp = v.Fields.gradeXp,
                        damageReflect = v.Fields.damageReflect,
                        hiddenLevel = v.Fields.hiddenLevel,
                        wisdom = v.Fields.wisdom,
                        strenght = v.Fields.strenght,
                        intelligence = v.Fields.intelligence,
                        chance = v.Fields.chance,
                        agility = v.Fields.agility,
                        bonusRange = v.Fields.bonusRange,
                        startingSpellId = v.Fields.startingSpellId,
                        bonusCharacteristics = parseBonusCharacteristics(v.Fields.bonusCharacteristics.Fields)
                    }
                )
            end

            return ret
        end

        local parseDrops = function(drops)
            local ret = self.dictionary()
            for _, v in pairs(drops) do
                ret:add(v.Fields.objectId, v.Fields)
            end

            return ret
        end

        local monster = {
            id = data.id,
            race = data.race,
            grades = parseGrade(data.grades),
            isBoss = data.isBoss,
            drops = parseDrops(data.drops),
            subAreas = self.list:fromTable(data.subareas),
            favoriteSubareaId = data.favoriteSubareaId,
            isMiniBoss = data.isMiniBoss,
            isQuestMonster = data.isQuestMonster,
            correspondingMiniBossId = data.correspondingMiniBossId,
            canPlay = data.canPlay,
            canTackle = data.canTackle,
            canBePushed = data.canBePushed,
            canSwitchPos = data.canSwitchPos,
        }
        return monster
    else
        self.logger:warning("Monster with id " .. idMonster .. " not found", "Monsters")
    end
end

return monsters