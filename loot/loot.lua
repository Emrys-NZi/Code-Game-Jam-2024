Loot = class('Loot')

function Loot:initialize(parent)
    self.parent = parent
    self.x = self.parent.x
    self.y = self.parent.y
end
function Entity:remove()
    self.ent:remove(self)
end

require("loot.poele")
require("loot.hache")
require("loot.epee")
require("loot.plastron")
require("loot.casque")
require("loot.cape")
