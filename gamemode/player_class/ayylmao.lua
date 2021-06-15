local CHAMPION = {} 
CHAMPION.MoveSpeed = 170

CHAMPION.baseHealth = 1200 
CHAMPION.baseHealthRegen = 1.3
CHAMPION.baseMana = 2048
CHAMPION.mana = 2048
CHAMPION.baseManaRegen = 3
CHAMPION.DisplayName = "Ayylamo"

CHAMPION.IsRangedAttack = true
CHAMPION.BaseAttackRange = 200
CHAMPION.BaseAttackDamage = 90
CHAMPION.BaseAttackDelay = 0.7
CHAMPION.BaseAnimDelay = 0.25

CHAMPION.Model = "models/player/ctm_sas.mdl"
CHAMPION.Weapon = "lw_anna"

CHAMPION.Abilities = {"spell1", "spell2", "spell3", "spell4"}

LW.Champions:Register( CHAMPION )