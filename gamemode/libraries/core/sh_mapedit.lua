AddCSLuaFile()

map = map || {}
map.gridCursor = map.gridCursor || Vector(0, 0)



local mins = Vector(1, 1, 1) * 16
local maxs = Vector(1, 1, 0) * -16
function map:Render()
	local hitpos = util.ScreenToVector().HitPos
	if (hitpos.y > self.gridCursor.y + 16) then
		self.gridCursor.y = self.gridCursor.y + 32
	elseif (hitpos.y < self.gridCursor.y - 16) then
		self.gridCursor.y = self.gridCursor.y - 32
	end
	
	if (hitpos.x > self.gridCursor.x + 16) then
		self.gridCursor.x = self.gridCursor.x + 32
	elseif (hitpos.x < self.gridCursor.x - 16) then
		self.gridCursor.x = self.gridCursor.x - 32
	end
	
	render.DrawWireframeBox(Vector(self.gridCursor.x, self.gridCursor.y), Angle(), mins, maxs, Color(255, 255, 255), false)
end