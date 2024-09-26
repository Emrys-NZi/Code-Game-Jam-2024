Entity = class('Entity')

function Entity:initialize(x, y, ent)
    if ent == nil then ent = entities end
    self.ent = ent
    self.ent:insert(self)
    
    self.x = x
    self.y = y
end
function Entity:remove()
    self.ent:remove(self)
end

require("entity.player")
require("entity.enemy")
require("entity.crow")
require("entity.poulicier")
require("entity.door")
require("entity.menu")