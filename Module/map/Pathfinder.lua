local pathfinder = {
    dependencies = {"json"},
    pathLoaded = false,
    cacheKey = "",
    path = {},
    url = "https://api.dofus-touch.yaya-digital.fr/"
}

function pathfinder:moveToWard(goalMapId, goalCellId)
    if tostring(map:currentMapId()) ~= tostring(goalMapId) then
        goalCellId = goalCellId or "-1"
        local cacheKey = goalMapId .. "," .. goalCellId

        if self.cacheKey ~= cacheKey then
            self.pathLoaded = false
            self.cacheKey = cacheKey
        end

        if not self.pathLoaded then
            local function mapWithMostCells(maps)
                local maxCells = 0
                local mapWithMost = nil
                for _, map in pairs(maps) do
                    local cellCount = #map.cells -- Compte le nombre de cells dans la table cells
                    if cellCount > maxCells then
                        maxCells = cellCount
                        mapWithMost = map
                    end
                end
                return mapWithMost
            end
            self.logger:info("Chargement du path", "Pathfinder")
            local goodGoalCellId = goalCellId
            if goalCellId == "-1" then
                local maps = self:getMaps(goalMapId)
                goodGoalCellId = mapWithMostCells(maps).cells[1]
            end
            local path = self:getPathTo(map:currentMapId(), map:currentCell(), goalMapId, goodGoalCellId)
            if path then
                self.path = path
                self.pathLoaded = true
                self.logger:info("Path chargée", "Pathfinder")
            else
                self.logger:error("Impossible de trouver un path pour la mapid: " .. goalMapId .. " cellid: " .. goalCellId .. ", depuis la mapid: " .. map:currentMapId() .. " cellid: " .. map:currentCell(), "Pathfinder")
            end
        end


        if self.pathLoaded then
            for i, v in pairs(self.path) do
                if v.direction == nil then
                    self.logger:error("Aucune direction pour la map: " .. v.mapId, "Pathfinder")
                end
                if tostring(v.mapId) == tostring(map:currentMapId()) then
                    local dir = v.direction
                    local maps
                    if i == #self.path then -- Dernière map
                        maps = self:getMaps(goalMapId)
                        if #maps == 1 then -- Si la prochaine map est unique, on utilise une cellid de changement de map aléatoire
                            dir = string.match(v.direction, "(.+)%(")
                        else -- Sinon on utilise la direction avec la cellid de changement de map
                            dir = v.direction
                        end
                    else -- Pendant le trajet
                        maps = self:getMaps(self.path[i + 1].mapId)
                        if #maps == 1 then
                            dir = string.match(v.direction, "(.+)%(")
                        else
                            dir = v.direction
                        end
                    end
                    self.logger:info("Map: (" .. v.mapId .. "), Change map to: " .. dir, "Pathfinder")
                    map:changeMap(dir)
                end
            end
        end
    else
        self.logger:info("Arrivé sur la map d'arrivé !", "Pathfinder")
    end
end

function pathfinder:getPathTo(startMapId, startCellId, goalMapId, goalCellId)
    local response = developer:getRequest(self.url .. "pathfinding/touch/pathByMapId?startMapId=" .. startMapId .. "&startCellId=" .. startCellId .. "&goalMapId=" .. goalMapId .. "&goalCellId=" .. goalCellId)

    --self.logger:log(response)
    
    if response then
        local decoded = self.json:decode(response)
        --self.logger:log(response)
        if decoded.status == 200 then
            return decoded.data.pathData
        else
            self.logger:error(decoded.message)
        end
    else
        self.logger:warning("Failed to get path", "Pathfinder")
    end
end

function pathfinder:getMaps(mapId)
    local response = developer:getRequest(self.url .. "maps/touch/getMapsByMapId?mapId=" .. mapId)
    if response then
        local decoded = self.json:decode(response)
        if decoded.status == 200 then
            return decoded.data
        else
            self.logger:error(decoded.message)
        end
    else
        self.logger:warning("Failed to get path", "Pathfinder")
    end
end

return pathfinder