local pathfinder = {
    dependencies = {"json"},
    pathLoaded = false,
    cacheKey = "",
    path = {},
    url = "https://api.dofus-touch.yaya-digital.fr/"
}

function pathfinder:moveToWard(goalMapId, goalCellId)
    if tostring(map:currentMapId()) ~= tostring(goalMapId) then
        local cacheKey = goalMapId .. "," .. goalCellId

        if self.cacheKey ~= cacheKey then
            self.pathLoaded = false
            self.cacheKey = cacheKey
        end

        if not self.pathLoaded then
            self.logger:info("Chargement du path", "Pathfinder")
            local path = self:getPathTo(map:currentMapId(), map:currentCell(), goalMapId, goalCellId)
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
                    if i == #self.path then
                        if #self:getMaps(goalMapId) == 1 then
                            dir = string.match(v.direction, "(.+)%(")
                        end
                    else
                        if #self:getMaps(self.path[i + 1].mapId) == 1 then
                            dir = string.match(v.direction, "(.+)%(")
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
    if response then
        local decoded = self.json:decode(response)
        if decoded.data.pathData then
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
        if decoded.status == "200" then
            return decoded.data
        else
            self.logger:error(decoded.message)
        end
    else
        self.logger:warning("Failed to get path", "Pathfinder")
    end
end

return pathfinder