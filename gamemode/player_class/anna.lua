local PLAYER = {} 

PLAYER.WalkSpeed = 300
PLAYER.RunSpeed	= 350
PLAYER.MoveSpeed = 170

PLAYER.baseHealth = 1200 
PLAYER.baseHealthRegen = 1.3
PLAYER.baseMana = 2048
PLAYER.mana = 2048
PLAYER.baseManaRegen = 3
PLAYER.DisplayName = "Anna"

PLAYER.IsRangedAttack = true
PLAYER.BaseAttackRange = 200
PLAYER.BaseAttackDamage = 90
PLAYER.BaseAttackDelay = 0.7
PLAYER.BaseAnimDelay = 0.25

PLAYER.Model = "models/player/alyx.mdl"
PLAYER.Weapon = "lw_anna"

function PLAYER.spellQ(ply, tpos, ang2D)
	local ent = ents.Create("projectile_ezreal_mysticshot")
	ent:SetPos(ply:GetForwardPos(tpos))
	ent:SetAngles(ang2D)
	ent:SetOwner(ply)
	ent:Spawn()

	ply:ResetLuaAnimation("leesin_sw")
end

function PLAYER.spellW(ply, tpos, ang2D)
	local ent = ents.Create("projectile_ezreal_essenceflux")
	ent:SetPos(ply:GetForwardPos(tpos))
	ent:SetAngles(ang2D)
	ent:SetOwner(ply)
	ent:Spawn()

	ply:ResetLuaAnimation("leesin_sw")
end

function PLAYER.spellE(ply, targetPos, ang2D)
	local aimVec = ang2D:Forward()

	local effectdata = EffectData()
	effectdata:SetStart(ply:GetShootPos())
	effectdata:SetOrigin(ply:GetPos())
	effectdata:SetScale(3)
	util.Effect("ManhackSparks", effectdata)

	local offset = targetPos - ply:GetPos()
	local normal = offset:GetNormal()
	local dist = offset:Length2D()
	if (dist > 300) then
		targetPos = ply:GetPos() + normal * 150
	end

	ply:EmitSound("lw/champions/ezreal/ezreal_arcaneshift_flash_" ..math.random(1, 3).. ".wav", 100)
	ply:SetPos(targetPos)

	ply:ResetLuaAnimation("leesin_tp")

	local players = player.GetAll()
	for k, v in ipairs(players) do
		if (v == ply) then continue end
		if (v:Team() == ply:Team() ) then continue end
		local dist = (v:GetPos() - ply:GetPos()):Length2D()
		if (dist > 120) then continue end
		v:GiveDamage(150, DMG_AD, ply)
	end
	
end

function PLAYER.spellR(ply, tpos, ang2D)
	local ent = ents.Create("projectile_ezreal_trueshot")
	ent:SetPos(ply:GetForwardPos(tpos))
	ent:SetAngles(ang2D)
	ent:SetOwner(ply)
	ent:Spawn()
end

PLAYER.passive = {
	--wondering if this should be a table or just a function?
}

--TODO: rename all maker_* to marker_*
PLAYER.abilities = {
	{
		name = "Disintegrate",
		icon = "lw/champions/anna/q.png",
		channeling = 0.25,
		cooldown = 2.5,
		desc = "Shoot the shot",
		key = "Q",
		dmg = 0,
		manaCost = 100,
		onCast = PLAYER.spellQ,
		maker_w = 25,
		maker_d = 300,
	},
	{
		name = "Incinerate",
		icon = "lw/champions/anna/w.png",
		channeling = 0.25,
		cooldown = 4.5,
		desc = "Shoot the shot",
		key = "W",
		dmg = 0,
		manaCost = 150,
		onCast = PLAYER.spellW,
		maker_w = 25,
		maker_d = 250
	},
	{
		name = "Molten Shield",
		icon = "lw/champions/anna/e.png",
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
		name = "Summon: Tibbers",
		icon = "lw/champions/anna/r.png",
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
player_manager.RegisterClass( "Anna", PLAYER, "hero_base" )

-- My Animations just testing
// leesin
RegisterLuaAnimation('leesin_sw', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = 33.375,
					RR = -18.8215
				},
				['ValveBiped.Bip01_R_Hand'] = {
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = -21.5051,
					RR = 38.0679,
					RF = -84.1463
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -32
				}
			},
			FrameRate = 20
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -39.8727,
					RR = 42.4007
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 44.233,
					RR = 3.9456,
					RF = 12.6227
				},
				['ValveBiped.Bip01_Spine4'] = {
					RR = -20.4417
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 77.8927,
					RR = 29.4996
				}
			},
			FrameRate = 6.6666666666667
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				},
				['ValveBiped.Bip01_Spine4'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
				}
			},
			FrameRate = 1.4286
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('leesin_rs', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_Calf'] = {
					RU = -48.118668401483
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -40.120560451189,
					RR = 27.297842083732
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 114.80448490169,
					RR = 16.577048214067
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -55.748895322999,
					RR = 46.612052534908
				},
				['ValveBiped.Bip01_Spine1'] = {
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -63.297655564603
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 90.659582445117,
					RR = 31.319578687896
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = -16.151956932286,
					RR = -1.0011067668958
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 91.489158755928,
					RR = -10.58464750011,
					RF = -26.005222357165
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -102.90317256355
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 2,
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('leesin_sg', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -82.586476112351,
					RR = 57.399215440401,
					RF = 32.120353875893
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = 52.584801748015,
					RR = -40.286509359468,
					RF = 5.2354960106069
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 46.256351215788,
					RR = -14.43413681859
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = -0.59827609525082,
					RR = 30.566984284292
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = 53.601342961883,
					RR = -21.242921807471,
					RF = 31.625540380001
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 92.286811744332
				}
			},
			FrameRate = 1
		}
	},
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('leesin_tp', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -3.0023,
					RR = 120.8322,
					RF = 84.9847
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 108.7656,
					RR = -6.6983,
					RF = 1.2856
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				},
				['ValveBiped.Bip01_Spine'] = {
				},
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -90.146402191926,
					RR = 29.918117777965,
					RF = -15.7027
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -62.2951,
					RR = 17.3222
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 108.7656,
					RR = -6.6983,
					RF = 1.2856
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 72.1939
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -11.2303
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = 41.438474528813,
					MU = 0.4479,
					RR = 37.527698740613
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 64.9636,
					RR = -16.6195
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 75.4936,
					RR = -10.607
				}
			},
			FrameRate = 6.6666666666667
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				},
				['ValveBiped.Bip01_Spine'] = {
				},
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				}
			},
			FrameRate = 2
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('leesin_cp', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -134.01562243065,
					RR = 2.3184001153788,
					RF = -45.575577090187
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				},
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_Spine'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 108.7656,
					RR = -6.6983,
					RF = 1.2856
				}
			},
			FrameRate = 5
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = 23.253008652727,
					RR = 25.245861346151,
					RF = 66.901795216307
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -62.2951,
					RR = 17.3222
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 39.99137817678,
					RR = 3.487221454641
				},
				['ValveBiped.Bip01_R_Calf'] = {
					RU = 64.9636,
					RR = -16.6195
				},
				['ValveBiped.Bip01_Spine'] = {
					RU = -2.1087046656293,
					MU = 0.4479,
					RR = 19.85203310639
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -11.2303
				},
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 72.1939
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 108.7656,
					RR = -6.6983,
					RF = 1.2856
				}
			},
			FrameRate = 5
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				},
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_Spine'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				},
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
				}
			},
			FrameRate = 2
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('leesin_dr', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Calf'] = {
					RU = 66.572316570345,
					RR = -1.1352348526208
				},
				['ValveBiped.Bip01_R_Thigh'] = {
					RU = -75.319399075152,
					RR = 15.652412558106,
					RF = -4.8102085950708
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 84.013858706219,
					RR = -0.99265586996498
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -19.628354220194,
					RR = 77.948809650884
				},
				['ValveBiped.Bip01_L_Thigh'] = {
					RU = -37.387371727956,
					RR = 33.364773698206,
					RF = -34.017193058809
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = 22.222222222222,
					RR = 360,
					MF = 18.740202498214
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -86.938467643971
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 112.2948874946,
					RR = 14.006218489167
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Calf'] = {
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Thigh'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RR = 360
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
				}
			},
			FrameRate = 2.5
		}
	},
	Type = TYPE_GESTURE
})