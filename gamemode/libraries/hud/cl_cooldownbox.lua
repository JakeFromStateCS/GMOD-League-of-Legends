LW.cd = LW.cd || {}
LW.cd.sizes = LW.cd.sizes || {}

function LW.cd:getData(w, h, add)
	local tab = self.sizes[w .. " " .. h]
	if (tab) then
		return tab
	elseif (add) then
		return self:addSize(w, h)
	end
end

function LW.cd:addSize(w, h)
	local vert = {
		{
			{x = 0, y = -(h / 2)},
			{x = w / 2, y = -(h / 2), c = function()
				return -(w / 2), 0
			end},
		},
		{
			{x = w / 2, y = -(h / 2)},
			{x = w / 2, y = 0, c = function()
				return 0, -(h / 2)
			end},
		},
		{
			{x = w / 2, y = 0, u = 1, v = 0.5},
			{x = w / 2, y = h / 2, c = function()
				return 0, -(h / 2)
			end},
		},
		{
			{x = w / 2, y = h / 2,},
			{x = 0, y = h / 2, c = function()
				return w / 2, 0
			end},
		},
		{
			{x = 0, y = h / 2},
			{x = -(w / 2), y = h / 2, c = function()
				return w / 2, 0
			end},
		},
		{
			{x = -(w / 2), y = h / 2},
			{x = -(w / 2), y = 0, c = function()
				return 0, h / 2
			end},
		},
		{
			{x = -(w / 2), y = 0},
			{x = -(w / 2), y = -(h / 2), c = function()
				return 0, h / 2
			end},
		},
		{
			{x = -(w / 2), y = -(h / 2)},
			{x = 0, y = -(h / 2), c = function()
				return -(w / 2), 0
			end},
		},
	}

	local tab = table.Copy(vert)

	self.sizes[w .. " " .. h] = {
		vert = vert,
		copiedVert = tab
	}
	
	return self.sizes[w .. " " .. h]
end

function LW.cd:DrawBox(x, y, w, h, p, color, center)
	local num = 8
	local oct = math.Clamp((num / 100) * p, 0, num)
	if (oct == num) then return end

	if (!center) then
		x = x + (w / 2)
		y = y + (h / 2)
	end

	local tab = self:getData(w, h, true)
	local poly = {{x = x, y = y}}
	for i = 1, num do
		if (math.ceil(oct) == i) then
			local frac = 1 - (i - oct)
			local nx, ny = tab.copiedVert[i][2].c()

			tab.copiedVert[i][1].x = x + tab.vert[i][1].x + (-nx * frac)
			tab.copiedVert[i][1].y = y + tab.vert[i][1].y + (-ny * frac)
			tab.copiedVert[i][2].x = x + tab.vert[i][2].x
			tab.copiedVert[i][2].y = y + tab.vert[i][2].y

			table.Add(poly, tab.copiedVert[i])
		elseif (oct < i) then
			for j = 1, 2 do
				tab.copiedVert[i][j].x = x + tab.vert[i][j].x
				tab.copiedVert[i][j].y = y + tab.vert[i][j].y
			end

			table.Add(poly, tab.copiedVert[i])
		end
	end

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	draw.NoTexture()
	surface.DrawPoly(poly)
end