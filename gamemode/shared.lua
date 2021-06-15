LW = LW or GM or GAMEMODE;

GM.Name 	= "League Wars"
GM.Author 	= "Hacksore / LOL / JakeFromStateCS"

TEAM_PURPLE = 1
TEAM_BLUE = 2
TEAM_SPEC = TEAM_SPECTATOR
TEAM_CON = TEAM_CONNECTING

DMG_AD = DMG_BULLET
DMG_AP = DMG_CRUSH
DMG_TD = DMG_GENERIC

DMG_TYPES = { 
	[DMG_AP] = "Ability Power",
	[DMG_AD] = "Attack Damage",
	[DMG_TD] = "True Damage"
}

STATE_IDLE = 0
STATE_MOVE = 1
STATE_CHASE = 2
STATE_ATTACK = 3
STATE_CHANNEL = 4

function LW:AddDirectory(path, soundFile)
    local files, folders = file.Find(path .. "/*", "GAME")
    for k, v in pairs(files) do
		if SERVER then
			resource.AddFile(path .. "/" .. v)
		end
		if soundFile then
			util.PrecacheSound(path .. "/" .. v)
		end
    end
    
    for k, v in pairs(folders) do
        self:AddDirectory(path .. "/" .. v)
    end
end

function LW:AddResource()

	LW:AddDirectory("sound/lw", true)
	LW:AddDirectory("sound/emote", true)

	if (SERVER) then
		LW:AddDirectory("materials/lw/lol", false)
		LW:AddDirectory("models/lw/lol", false)
	end
end

LW:AddResource()

function GM:CreateTeams()
	team.SetUp(TEAM_CON, "Unconnected", Color(237, 255, 158, 255), false)
	team.SetUp(TEAM_SPEC, "Spectators", Color(193, 193, 193, 255), true)
	team.SetUp(TEAM_PURPLE, "Purple", Color(201, 50, 198, 255), false)
	team.SetUp(TEAM_BLUE, "Blue", Color(109, 150, 255, 255), false)

	team.SetSpawnPoint(TEAM_PURPLE, "info_player_terrorist")
	team.SetSpawnPoint(TEAM_BLUE, "info_player_counterterrorist")
end

function GM:PlayerFootstep() return true end

function GM:Think()
	if (LW.Update) then LW:Update() end
end