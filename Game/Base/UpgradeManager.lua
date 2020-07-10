---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Upgrade Tables

PlayerMovementUpgrades = {
  {
    cost = 0,
    value = 7
  },
  {
    cost = 5,
    value = 8.5
  },
  {
    cost = 15,
    value = 9.5
  },
  {
    cost = 30,
    value = 11.5
  }
}

PlayerBatUpgrades = {
  {
    cost = 0,
    value = 1
  },
  {
    cost = 15,
    value = 2
  },
  {
    cost = 40,
    value = 3
  }
}

PlayerLuckUpgrades = {
  {
    cost = 0,
    value = 1,
  },
  {
    cost = 7,
    value = 1.25
  },
  {
    cost = 21,
    value = 1.75
  },
  {
    cost = 35,
    value = 2.5
  },
  {
    cost = 80,
    value = 3
  }
}

PlayerCarryingUpgrades = {
  {
    cost = 0,
    value = 5
  },
  {
    cost = 12,
    value = 10
  },
  {
    cost = 28,
    value = 15
  },
  {
    cost = 50,
    value = 20
  }
}

--Value is spawn
TruckFastUpgrades = {
  {
    cost = 0,
    value = 8
  },
  {
    cost = 0,
    value = 3
  }
}

--Value is spawn
TruckQualityUpgrades = {
  {
    cost = 0,
    value = false
  },
  {
    cost = 0,
    value = true
  }
}

ChairQualityUpgrades = {
  {
    cost = 0,
    value = function(ch)
      ch:setImage("Chair.png")
      ch.quality = false
      ch.maxHealth = 3
      ch.woodAmount = math.random(1, 2)
    end
  },
  {
    cost = 0,
    value = function(ch)
      ch:setImage("QualityChair.png")
      ch.quality = true
      ch.maxHealth = 5
      ch.woodAmount = math.random(2, 4)
    end
  }
}

FurnaceRequirements = {
  {
    value = 1,
    time = 0
  },
  {
    value = 5,
    time = 40,
  },
  {
    value = 10,
    time = 60
  },
  {
    value = 25,
    time = 90
  },
  {
    value = 40,
    time = 90
  },
  {
    value = 60,
    time = 120
  },
  {
    value = 70,
    time = 120
  },
  {
    value = 80,
    time = 120
  },
  {
    value = 90,
    time = 90
  }
}

UpgradeReference = {
  [TruckFastUpgrades] = "TruckFastUpgrades",
  [TruckQualityUpgrades] = "TruckQualityUpgrades"
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UpgradeManager = {
  upgradedObjects = {}
}

function UpgradeManager:addUpgradeToObject(upgradeTable, rank, objHandle) 
  if self.upgradedObjects[objHandle.id] == nil then
    self.upgradedObjects[objHandle.id] = {}
  end

  self.upgradedObjects[objHandle.id][upgradeTable] = rank
  if objHandle.onUpgrade then
    objHandle:onUpgrade(upgradeTable, rank)
  end
end

function UpgradeManager:getUpgradeRank(objHandle, upgradeTable) 
  if self.upgradedObjects[objHandle.id] == nil then
    return 1
  end

  if self.upgradedObjects[objHandle.id][upgradeTable] == nil then
    return 1
  end
   
  return self.upgradedObjects[objHandle.id][upgradeTable]
end

function UpgradeManager:getNextUpgradeCost(objHandle, upgradeTable) 
  if upgradeTable[self:getUpgradeRank(objHandle, upgradeTable) + 1] == nil then
    return nil
  end

  return upgradeTable[self:getUpgradeRank(objHandle, upgradeTable) + 1].cost
end

function UpgradeManager:getRankValue(objHandle, upgradeTable) 
  return upgradeTable[self:getUpgradeRank(objHandle, upgradeTable)].value
end