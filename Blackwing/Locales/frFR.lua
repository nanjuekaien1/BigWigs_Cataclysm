
local L = BigWigs:NewBossLocale("Magmaw", "frFR")
if not L then return end
if L then
	L.stage2_yell_trigger = "Inconcevable ! Vous pourriez vraiment vaincre mon ver de lave !"

	L.slump = "Affalement"
	L.slump_desc = "Prévient quand le boss s'affale vers l'avant et s'expose, permettant ainsi au rodéo de commencer."
	L.slump_bar = "Rodéo"
	L.slump_message = "Yeehaw, chevauchez !"
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "frFR")
if L then
	L.nef = "Seigneur Victor Nefarius"
	L.nef_desc = "Prévient quand le Seigneur Victor Nefarius utilise une technique."

	L.pool_explosion = "Générateur instable"
	L.incinerate = "Incinérer"
	L.flamethrower = "Lance-flammes"
	L.lightning = "Foudre"
	L.infusion = "Infusion"
end

L = BigWigs:NewBossLocale("Atramedes", "frFR")
if L then
	L.obnoxious_fiend = "Démon odieux" -- NPC ID 49740
	L.air_phase_trigger = "Oui, fuyez ! Chaque foulée accélère votre cœur. Les battements résonnent comme le tonnerre... Assourdissant. Vous ne vous échapperez pas !"
	--L.circles = "Circles"
end

L = BigWigs:NewBossLocale("Maloriak", "frFR")
if L then
	L.flames = "Flammes"
end

L = BigWigs:NewBossLocale("Nefarian", "frFR")
if L then
	L.discharge = "Décharge"
	L.stage3_yell_trigger = "J'ai tout fait pour être un hôte accommodant"
	L.shadowblaze_yell_trigger = "Que la chair se transforme en cendres !"
	--L.too_close = "Dragons are too close"
end
