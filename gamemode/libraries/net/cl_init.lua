net.Receive("lw_cooldown", function()
	local key = net.ReadInt(4)
	local ct = net.ReadFloat()
	local cooldown = net.ReadFloat()

	client.cooldown[key].cooldown = ct + cooldown
	client.cooldown[key].sec = cooldown
	client.cooldown[key].alpha = 255

	client._state = client._oldstate
end)

net.Receive("lw_channeling", function()
	local key = net.ReadInt(4)
	local ct = net.ReadFloat()
	local channeling = net.ReadFloat()

	client.channeling.time = ct + channeling
	client.channeling.sec = channeling
	client.channeling.key = key

	client._oldstate = client._state
	client._viewAng = client._oldViewAng
	client._state = STATE_CHANNEL
end)

net.Receive("lw_recall_inform", function()
	
	local ply = player.GetByID(net.ReadInt(32))
	local bool = net.ReadBool()
	ply.isRecalling = bool
	print("recall: " .. tostring(bool))
	--print(bool)
end)