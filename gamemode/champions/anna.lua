local CHAMPION = {};
CHAMPION.Name = "Anna";
CHAMPION.Model = "models/player/alyx.mdl";

CHAMPION.BaseStats = {
	Health = {
		Base = 1200,
		Regen = 1.3
	},
	Mana = {
		Base = 2048,
		Regen = 3
	},
	Attack = {
		Range = 200,
		Damage = 90,
		Speed = 0.7,
		AnimDelay = 0.25
	},
	Armor = {
		Base = 0,
		Penetration = 0
	},
	Magic = {
		Resist = 0,
		Penetration = 0
	},
	Ability = {
		Power = 0,
		Penetration = 0
	},
	Movement = {
		Speed = 170
	}
};

CHAMPION.Scaling = {
	Health = 0.1,
	Mana = 0.1,
	AD = 2,
	AP = 4,
	AttackRange = 0,
	MoveSpeed = 0
};

CHAMPION.Abilities = {
	"Disintegrate",
	"Incinerate",
	"Molten Shield",
	"Summon: Tibbers"
};


LW.Champions:Register( CHAMPION );