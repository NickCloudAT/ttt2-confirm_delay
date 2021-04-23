if SERVER then

  util.AddNetworkString("ttt_cdleay_delay")


  hook.Add("TTTCanSearchCorpse", "ttt_cdelay_checktime", function(ply, corpse)
    if not GetConVar("ttt_confirmdelay_enable"):GetBool() or GetRoundState() ~= ROUND_ACTIVE or CORPSE.GetFound(corpse, false) then return end
    if ply:GetBaseRole() == ROLE_DETECTIVE then return end

    local death_time = corpse.time
    local cur_time = CurTime()
    local cvar_delay = GetConVar("ttt_confirmdelay_delay"):GetInt()

    if cur_time >= death_time+cvar_delay then return end

    net.Start("ttt_cdleay_delay")
    net.WriteUInt((death_time+cvar_delay)-cur_time, 16)
    net.Send(ply)

    return false
  end)

end

if CLIENT then

  net.Receive("ttt_cdleay_delay", function()
    local delay_time = net.ReadUInt(16)

    MSTACK:AddColoredMessage(LANG.GetParamTranslation("ttt_cdelay_delaymsg", {delay = delay_time}))

  end)

end
