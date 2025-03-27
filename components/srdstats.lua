local function shallowcopy(t)
   local nt = {}
   for k, v in pairs(t) do
      nt[k] = v
   end
end

--- @class SRDStatsComponent : Component
--- @field stats table<string, boolean>
--- @field movePoints integer
--- @field curMovePoints integer
--- @field naturalAC integer
--- @field HP integer
--- @field actionSlots table<string, boolean>
--- @field attacks SparseArray
--- @field mask Bitmask
local SRDStats = prism.Component:extend( "SRDStatsComponent" )
SRDStats.name = "Move"

SRDStats.actions = {
   prism.actions.EndTurn,
   prism.actions.Move,
   prism.actions.Attack
}

local statsRequired = {
   STR = true,
   DEX = true,
   CON = true,
   WIS = true,
   CHA = true,
   INT = true
}

local actionSlots = {
   "Action",
   "BonusAction",
   "FreeAction"
}

function SRDStats:__new(options)
   options = options or {}

   self.maxHP = options.maxHP or 10
   self.HP = self.maxHP 
   self.naturalAC = (options.naturalAC or 10)
   self.stats = options.stats
   self.movePoints = options.movePoints
   self.curMovePoints = options.movePoints
   self.actionSlots = {
      Action = true,
      BonusAction = true,
      ObjectInteraction = true
   }

   self.mask = prism.Collision.createBitmaskFromMovetypes(options.moveTypes)

   self.modifiers = {}

   for stat, _ in pairs(statsRequired) do
      self.modifiers[stat] = {}
   end

   self.attacks = prism.SparseArray()

   for _, attack in ipairs(options.attacks or {}) do
      self.attacks:add(attack)
   end
end

function SRDStats:addStatModifier(stat, modifier)
   if not self.modifiers[stat] then self.modifiers[stat] = {} end
   table.insert(self.modifiers[stat], modifier)
end

function SRDStats:getStat(stat)
   local finalStat = self.stats[stat]
   
   for _, mod in ipairs(self.modifiers[stat]) do
      finalStat = finalStat + mod
   end

   return finalStat
end

function SRDStats:getStatBonus(stat)
   local stat = self:getStat(stat)

   local normalized = stat - 10
   local reduced = normalized / 2
   local sign = 1
   if reduced < 0 then
      sign = -1
   end
   local floored = math.floor(math.abs(reduced))

   return floored * sign
end

function SRDStats:addAttack(attack)
   return self.attacks:add(attack)
end

function SRDStats:removeAttack(index)
   self.attacks:remove(index)
end

function SRDStats:resetOnTurn()
   self.curMovePoints = self.movePoints

   for _, slot in ipairs(actionSlots) do
      self.actionSlots[slot] = true
   end
end

return SRDStats
