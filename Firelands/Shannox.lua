--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shannox", 800, 195)
if not mod then return end
mod:RegisterEnableMob(53691, 53695, 53694) --Shannox, Rageface, Riplimb

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.safe = "%s safe"
	L.wary_dog = "%s is Wary!"
	L.crystal_trap = "Crystal Trap"

	L.traps_header = "Traps"
	L.immolation = "Immolation Trap on Dog"
	L.immolation_desc = "Alert when Rageface or Riplimb steps on an Immolation Trap, gaining the 'Wary' buff."
	L.immolation_icon = 100167
	L.immolationyou = "Immolation Trap under You"
	L.immolationyou_desc = "Alert when an Immolation Trap is summoned under you."
	L.immolationyou_icon = 99838
	L.immolationyou_message = "Immolation Trap"
	L.crystal = "Crystal Trap"
	L.crystal_desc = "Warn whom Shannox casts a Crystal Trap under."
	L.crystal_icon = 99836
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		100002, {100129, "ICON"}, "berserk", "bosskill",
		"immolation", {"immolationyou", "FLASH"}, {"crystal", "SAY", "FLASH"},
	}, {
		[100002] = "general",
		["immolation"] = L["traps_header"],
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "WaryDog", 99838)
	self:Log("SPELL_CAST_SUCCESS", "FaceRage", 99945, 99947)
	self:Log("SPELL_AURA_REMOVED", "FaceRageRemoved", 99945, 99947)
	self:Log("SPELL_CAST_SUCCESS", "HurlSpear", 99978)
	self:Log("SPELL_SUMMON", "Traps", 99836, 99839) -- Throw Crystal Prison Trap, Throw Immolation Trap

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 53691)
end

function mod:OnEngage()
	self:Bar(100002, 100002, 23, 100002) -- Hurl Spear
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local timer, fired = nil, 0
	local function trapWarn(spellId)
		fired = fired + 1
		local player = UnitName("boss1target")
		if player and (not UnitDetailedThreatSituation("boss1target", "boss1") or fired > 13) then
			-- If we've done 14 (0.7s) checks and still not passing the threat check, it's probably being cast on the tank
			if spellId == 99836 then
				mod:TargetMessage("crystal", L["crystal_trap"], player, "Urgent", spellId, "Alarm")
			end
			mod:CancelTimer(timer)
			timer = nil
			if UnitIsUnit("boss1target", "player") then
				if spellId == 99836 then
					mod:Flash("crystal")
					mod:Say("crystal", L["crystal_trap"])
				else
					mod:Flash("immolationyou")
					mod:LocalMessage("immolationyou", CL["underyou"]:format(L["immolationyou_message"]), "Personal", spellId, "Alarm")
				end
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer)
			timer = nil
		end
	end
	function mod:Traps(args)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(trapWarn, 0.05, args.spellId)
		end
	end
end

function mod:WaryDog(args)
	-- We use the Immolation Trap IDs as we only want to warn for Wary after a
	-- Immolation Trap not a Crystal Trap, which also applies Wary.
	local creatureId = self:MobId(args.destGUID)
	if creatureId == 53695 or creatureId == 53694 then
		self:Message("immolation", L["wary_dog"]:format(args.destName), "Attention", 100167)
		self:Bar("immolation", L["wary_dog"]:format(args.destName), self:Heroic() and 25 or 15, 100167)
	end
end

function mod:HurlSpear(args)
	self:Message(100002, args.spellName, "Attention", 100002, "Info")
	self:Bar(100002, args.spellName, 41, 100002)
end

function mod:FaceRage(args)
	self:TargetMessage(100129, args.spellName, args.destName, "Important", 100129, "Alert")
	self:PrimaryIcon(100129, args.destName)
end

function mod:FaceRageRemoved(args)
	self:Message(100129, L["safe"]:format(args.destName), "Positive", 100129)
	self:PrimaryIcon(100129)
end

