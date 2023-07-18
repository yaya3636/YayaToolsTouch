ModuleLoader = dofile(global:getCurrentDirectory() .. [[\YayaToolsTouch\Module\ModuleLoader.lua]])(1)
MapHelper = ModuleLoader:load("MapHelper")()
Logger = ModuleLoader:load("logger")(1)
Pathfinder = ModuleLoader:load("Pathfinder")()

Etape = 1


-- function pathfinder:moveToWard(goalMapId, goalCellId) goalMapId = mapId d'arrivé, goalCellId = une cellId "marchable" de la carte d'arrivé
-- Déplace le personnage de la carte actuelle jusqu'a la map d'arrivé

-- function pathfinder:getPathTo(startMapId, startCellId, goalMapId, goalCellId) startMapId = mapId de de départ, startCellId = une cellId "marchable" de la carte de départ, goalMapId = mapId d'arrivé, goalCellId = une cellId "marchable" de la carte d'arrivé
-- Retourne un chemin de la carte de départ a la carte d'arrivé dans une table, chaque éléments de la table  = { mapId = 0000, direction = "right(0)" }

function move()
    if Etape == 1 then
        Pathfinder:moveToWard(145447, 499)
    else
        Pathfinder:moveToWard(147768, 0)
    end

    if map:currentMapId() == 145447 then
        Etape = 2
        Pathfinder:moveToWard(147768, 0)
    end
end
