---@alias WeaponProperty
--- | "light"         # A smaller weapon that can be wielded in one hand for dual-wielding
--- | "finesse"       # Allows the use of Dexterity instead of Strength for attack and damage rolls
--- | "thrown"        # Can be thrown at a target; range is specified in weapon stats
--- | "two-handed"    # Requires two hands to use
--- | "versatile"     # Can be wielded with one or two hands; damage increases when used with two hands
--- | "heavy"         # Designed for larger creatures; small creatures have disadvantage when using it
--- | "reach"         # Extends melee range by 5 feet
--- | "loading"       # Requires time to reload before firing again; limits attacks per action
--- | "special"       # Has unique rules described in the weapon's entry
--- | "ammunition"    # Requires ammunition to attack; consumes ammo on use
--- | "improvised"    # A non-standard item used as a weapon, typically dealing 1d4 damage
--- | "magic"         # A magical weapon that bypasses resistance or immunity to non-magical attacks
--- | "unarmed"       # This attack counts as an unarmed strike.
--- | "natural"       # This is a natural weapon.
--- | "simple"        # This is a simple weapon.
--- | "martial"       # This is a martial weapon.
--- | "ranged"        # This is a ranged attack.

--- @alias DamageData {dice: DiceData|integer, type: DamageType}
--- @alias DamageTable [DamageData]
--- @alias RangeData {short:integer, long:integer|nil}|integer
--- @alias PropertyData table<WeaponProperty, boolean>
--- @alias AttackDataOptions { name: string, damage: DamageTable, range: RangeData, properties: PropertyData, tohitBonus: integer, damageBonus: integer, staticToHit: integer|nil}

--- @class AttackData : Object
--- @field name string
--- @field damage DamageTable
--- @field range RangeData
--- @field properties PropertyData
--- @field tohitBonus integer
--- @field damageBonus integer
--- @field staticToHit integer
--- @overload fun(options: AttackDataOptions)
--- @type AttackData
local AttackData = prism.Object:extend("AttackData")

---@param options AttackDataOptions
function AttackData:__new(options)
   self.name = options.name
   self.damage = options.damage
   
   if type(options.range) == "number" then
      ---@diagnostic disable-next-line
      self.range = {short = options.range, long = nil}
   else
      ---@diagnostic disable-next-line
      self.range = options.range or {short = 1, long = nil}
   end

   self.properties = options.properties
   self.tohitBonus = options.tohitBonus or 0
   self.damageBonus = options.damageBonus or 0
   self.staticToHit = options.staticToHit
end

return AttackData