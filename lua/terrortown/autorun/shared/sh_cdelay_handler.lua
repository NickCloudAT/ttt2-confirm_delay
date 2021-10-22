local function canSearch(death_time)
	local cur_time = CurTime()
	local cvar_delay = GetConVar("ttt_confirmdelay_delay"):GetInt()

	return cur_time >= death_time+cvar_delay
end

local function getTimeTillSearchable(death_time)
	local cur_time = CurTime()
	local cvar_delay = GetConVar("ttt_confirmdelay_delay"):GetInt()

	return (death_time+cvar_delay)-cur_time
end


if SERVER then

	util.AddNetworkString("ttt_cdleay_delay")


	hook.Add("TTTCanSearchCorpse", "ttt_confdelay_checktime", function(ply, corpse)
	if not GetConVar("ttt_confirmdelay_enable"):GetBool() or GetRoundState() ~= ROUND_ACTIVE or CORPSE.GetFound(corpse, false) then return end
	if ply:GetBaseRole() == ROLE_DETECTIVE and GetConVar("ttt_confirmdelay_detective_bypass"):GetBool() then return end

	local death_time = corpse.time

	if canSearch(death_time) then return end

	local cvar_delay = GetConVar("ttt_confirmdelay_delay"):GetInt()
	local cur_time = CurTime()

	net.Start("ttt_cdleay_delay")
	net.WriteUInt((death_time+cvar_delay)-cur_time, 16)
	net.Send(ply)

	return false
	end)

	hook.Add("TTTOnCorpseCreated", "TTT2_CONFDELAY_CORPSECREATE", function(rag, ply)
	if not IsValid(rag) then return end

	rag:SetNWInt("ttt2_confdelay_time", rag.time or CurTime())
	end)

end

if CLIENT then

	local GetPT = LANG.GetParamTranslation

	net.Receive("ttt_cdleay_delay", function()
	local delay_time = net.ReadUInt(16)

	MSTACK:AddColoredMessage(LANG.GetParamTranslation("ttt_confdelay_delaymsg", {delay = delay_time}))

	end)


	hook.Add("TTTRenderEntityInfo", "TTT2_CONFDELAY_TARGETID", function(tData)
	local ent = tData.data.ent

	if not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll" or not GetConVar("ttt_confirmdelay_enable"):GetBool() or (LocalPlayer():GetBaseRole() == ROLE_DETECTIVE and GetConVar("ttt_confirmdelay_detective_bypass"):GetBool()) then return end

	if CORPSE.GetFound(ent, false) then return end

	local death_time = ent:GetNWInt("ttt2_confdelay_time", 0)

	if tData:GetEntityDistance() > 100 or canSearch(death_time) then return end

	tData:AddDescriptionLine(GetPT("ttt_confdelay_targetid", {time = math.Round(getTimeTillSearchable(death_time))}))
	end)

end
