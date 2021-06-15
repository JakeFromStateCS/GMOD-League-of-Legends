hero_manager = {}
hero_manager.heros = {}

function hero_manager.addHero(class)
	hero_manager.heros[class.DisplayName] = class
end

function hero_manager.getHeros()
	return hero_manager.heros
end

function hero_manager.getHero(hero)
	return hero_manager.heros[hero]
end

function hero_manager.getCooldown(hero, sid)
	return hero_manager.heros[hero].abilities[sid].cooldown
end

function hero_manager.getManaCost(hero, sid)
	return hero_manager.heros[hero].abilities[sid].manaCost
end

function hero_manager.getMana(hero)
	return hero_manager.heros[hero].baseMana
end

function hero_manager.getAbilities(hero)
	return hero_manager.heros[hero].abilities
end
