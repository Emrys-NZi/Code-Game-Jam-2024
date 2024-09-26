input = {}
input.keys = {}
-- les touches par défaut doivent suivre l'emplacement des touches d'un clavier QWERTY américain
-- https://love2d.org/wiki/Scancode
input.keys["up"] = "w"
input.keys["left"] = "a"
input.keys["down"] = "s"
input.keys["right"] = "d"
input.keys["jump"] = "space"
input.keys["dash"] = "o"
input.keys["hit"] = "j"


function input:isDown(key)
    return love.keyboard.isScancodeDown(self.keys[key])
end