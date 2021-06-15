local PLAYER = {} 

PLAYER.WalkSpeed = 300
PLAYER.RunSpeed	= 350
PLAYER.MoveSpeed = 200

PLAYER.baseHealth = 825
PLAYER.baseHealthRegen = 1.3
PLAYER.baseMana = 2048
PLAYER.mana = 2048
PLAYER.baseManaRegen = 4
PLAYER.DisplayName = "Rektar"

PLAYER.IsRangedAttack = false
PLAYER.BaseAttackDamage = 800
PLAYER.BaseAttackRange = 70
PLAYER.BaseAttackDelay = 0.8
PLAYER.BaseAnimDelay = 0.3

PLAYER.Model = "models/player/odessa.mdl"
PLAYER.Weapon = "lw_anna"

function PLAYER.spellQ(ply, _, ang2D)
	local ent = ents.Create("projectile_ezreal_mysticshot")
	ent:SetPos(ply:GetShootPos())
	ent:SetAngles(ang2D)
	ent:SetOwner(ply)
	ent:Spawn()
end

function PLAYER.spellW(ply, _, ang2D)
	local ent = ents.Create("projectile_ezreal_essenceflux")
	ent:SetPos(ply:GetShootPos())
	ent:SetAngles(ang2D)
	ent:SetOwner(ply)
	ent:Spawn()
end

function PLAYER.spellE(ply, targetPos, ang2D)
	local aimVec = ang2D:Forward()

	local effectdata = EffectData()
	effectdata:SetStart(ply:GetShootPos())
	effectdata:SetOrigin(ply:GetPos())
	effectdata:SetScale(3)
	util.Effect("ManhackSparks", effectdata)

	local plys = ents.FindInSphere(ply:GetPos(), 300)

	ply:EmitSound("lw/champions/ezreal/ezreal_arcaneshift_flash_" ..math.random( 1, 3 ).. ".wav", 100)
	ply:SetPos(targetPos)

	local players = player.GetAll()

	for k, v in ipairs(players) do
		if (v == ply) then continue end
		if (v:Team() == ply:Team() ) then continue end
		local dist = (v:GetPos() - ply:GetPos()):Length2D()
		if (dist > 120) then continue end
		v:GiveDamage(150, DMG_AD, ply)
		break
	end -- very faster
end

function PLAYER.spellR(ply, _, ang2D)
	local ent = ents.Create("projectile_ezreal_trueshot")
	ent:SetPos(ply:GetShootPos())
	ent:SetAngles(ang2D)
	ent:SetOwner(ply)
	ent:Spawn()
end
PLAYER.abilities = {
	{
		name = "Mystic Shot",
		icon = "lw/champions/ezreal/q.png",
		channeling = 0.25,
		cooldown = 2.5,
		desc = "Shoot the shot",
		key = "Q",
		dmg = 0,
		manaCost = 70,
		onCast = PLAYER.spellQ,
		maker_w = 25,
		maker_d = 300,
	},
	{
		name = "Essence Flux",
		icon = "lw/champions/ezreal/w.png",
		channeling = 0.25,
		cooldown = 4.5,
		desc = "Shoot the shot",
		key = "W",
		dmg = 0,
		manaCost = 90,
		onCast = PLAYER.spellW,
		maker_w = 25,
		maker_d = 250
	},
	{
		name = "Arcane Shift",
		icon = "lw/champions/ezreal/e.png",
		channeling = 0.25,
		cooldown = 10,
		desc = "Shoot the shot",
		key = "E",
		dmg = 85,
		manaCost = 100,
		onCast = PLAYER.spellE,
		maker_r = 150
	},
	{
		name = "Trueshot Barrage",
		icon = "lw/champions/ezreal/r.png",
		channeling = 1,
		cooldown = 30,
		desc = "Shoot the shot",
		key = "R",
		dmg = 600,
		manaCost = 120,
		onCast = PLAYER.spellR,
		maker_g = true,
		maker_w = 40
	}
}


hero_manager.addHero(PLAYER)
player_manager.RegisterClass("Rektar", PLAYER, "hero_base")
