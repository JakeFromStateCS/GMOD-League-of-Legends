local PLAYER = {} 

PLAYER.WalkSpeed = 300
PLAYER.RunSpeed	= 350
PLAYER.MoveSpeed = 170

PLAYER.baseHealth = 1200 
PLAYER.baseHealthRegen = 1.3
PLAYER.baseMana = 2048
PLAYER.mana = 2048
PLAYER.baseManaRegen = 3
PLAYER.DisplayName = "Cat"

PLAYER.IsRangedAttack = true
PLAYER.BaseAttackRange = 200
PLAYER.BaseAttackDamage = 150
PLAYER.BaseAttackDelay = 0.7
PLAYER.BaseAnimDelay = 0.15

PLAYER.Model = "models/player/Group01/female_04.mdl"
PLAYER.Weapon = "lw_anna"

function PLAYER.spellQ(ply, tpos, ang2D)
	local ent = ents.Create("projectile_cat_q")
	ent:SetPos(ply:GetShootPos())
	ent:SetAngles(ang2D)
	ent:SetOwner(ply)
	ent:Spawn()
end

function PLAYER.spellW(ply, tpos, ang2D)

end

function PLAYER.spellE(ply, targetPos, ang2D)
	
	
end

function PLAYER.spellR(ply, tpos, ang2D)

end

PLAYER.abilities = {
	{
		name = "Mystic Shot",
		icon = "lw/champions/ezreal/q.png",
		channeling = 0,
		cooldown = 3,
		desc = "Shoot the shot",
		key = "Q",
		dmg = 0,
		manaCost = 0,
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
		channeling = 15,
		cooldown = 30,
		desc = "Shoot the shot",
		key = "R",
		dmg = 200,
		manaCost = 120,
		onCast = PLAYER.spellR,
		maker_g = true,
		maker_w = 40
	}
}

hero_manager.addHero(PLAYER)
player_manager.RegisterClass( "Cat", PLAYER, "hero_base" )
