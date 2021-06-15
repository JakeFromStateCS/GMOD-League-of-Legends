LW.cam = LW.cam || {}
LW.cam.view = LW.cam.view || {}

local maxZoom = 350
function LW.cam:Init()
	self.view.ang = Angle(65, 0, 0)
	
	local dir = self.view.ang:Forward()
	self.view.pos = client:GetPos() + dir * -maxZoom
	self.view.origin = self.view.pos
	
	self.view.zoom = Vector()
	self.view.zoom_amt = 0
	self.view.zoom_smooth = 0
	
	self.view.fixed = false
end

function LW.cam:CamView()
	local view = {}
	view.origin = self.view.origin
	view.angles = self.view.ang
	view.fov = 90
	view.drawviewer = true

	return view
end

local mousetrigger = 10
local camspeed = 1000
function LW.cam:Update()
	if (!system.HasFocus()) then return end

	local camPos = self.view.pos
	local origin = camPos
	
	if (self.view.fixed) then
		origin = (client:GetPos() +  self.view.ang:Forward() * -maxZoom)
		self.view.pos = origin
	else
		local mx, my = LW.input:GetCursorPos()
		
		if (mx <= mousetrigger && my <= mousetrigger) then
			camPos.x = camPos.x + (camspeed / 1.5) * FrameTime()
			camPos.y = camPos.y + (camspeed / 1.5) * FrameTime()
		elseif (mx >= (sw - mousetrigger) && my <= mousetrigger) then
			camPos.x = camPos.x + (camspeed / 1.5) * FrameTime()
			camPos.y = camPos.y - (camspeed / 1.5) * FrameTime()
		elseif (mx >= (sw - mousetrigger) && my >= (sh - mousetrigger)) then
			camPos.x = camPos.x - (camspeed / 1.5) * FrameTime()
			camPos.y = camPos.y - (camspeed / 1.5) * FrameTime()
		elseif (mx <= mousetrigger && my >= (sh - mousetrigger)) then
			camPos.x = camPos.x - (camspeed / 1.5) * FrameTime()
			camPos.y = camPos.y + (camspeed / 1.5) * FrameTime()
		elseif (mx <= mousetrigger) then
			camPos.y = camPos.y + camspeed * FrameTime()
		elseif (my <= mousetrigger) then
			camPos.x = camPos.x + camspeed * FrameTime()
		elseif (mx >= (sw - mousetrigger)) then
			camPos.y = camPos.y - camspeed * FrameTime()
		elseif (my >= (sh - mousetrigger)) then
			camPos.x = camPos.x - camspeed * FrameTime()
		end
		
		origin = camPos
	end

	self.view.origin = origin + self.view.zoom
end

local zoomSpeed = 50
function LW.cam:ZoomUpdate(dt)
	self.view.zoom_amt = math.Clamp(self.view.zoom_amt + dt * zoomSpeed, 0, maxZoom - 70)
	self.view.zoom_smooth = Lerp(4 * RealFrameTime(), self.view.zoom_smooth, self.view.zoom_amt)

	self.view.zoom = self.view.ang:Forward() * self.view.zoom_smooth
end