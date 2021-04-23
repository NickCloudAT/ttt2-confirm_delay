CreateConVar("ttt_confirmdelay_enable", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
CreateConVar("ttt_confirmdelay_delay", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})


hook.Add("TTTUlxInitCustomCVar", "TTTCDelayInitRWCVar", function(name)
	ULib.replicatedWritableCvar("ttt_confirmdelay_enable", "rep_ttt_confirmdelay_enable", GetConVar("ttt_confirmdelay_enable"):GetInt(), true, false, name)
	ULib.replicatedWritableCvar("ttt_confirmdelay_delay", "rep_ttt_confirmdelay_delay", GetConVar("ttt_confirmdelay_delay"):GetInt(), true, false, name)
end)


if CLIENT then
  hook.Add("TTTUlxModifyAddonSettings", "TTTCDelayModifySettings", function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		-- Basic Settings
		local tttrsclp1 = vgui.Create("DCollapsibleCategory", tttrspnl)
		tttrsclp1:SetSize(390, 50)
		tttrsclp1:SetExpanded(1)
		tttrsclp1:SetLabel("Basic Settings")

		local tttrslst1 = vgui.Create("DPanelList", tttrsclp1)
		tttrslst1:SetPos(5, 25)
		tttrslst1:SetSize(390, 50)
		tttrslst1:SetSpacing(5)

    tttrslst1:AddItem(xlib.makecheckbox{
      label = "ttt_confirmdelay_enable (def. 0)",
      repconvar = "rep_ttt_confirmdelay_enable",
      parent = tttrslst1})

    tttrslst1:AddItem(xlib.makeslider{
			label = "ttt_confirmdelay_delay (Def. 30)",
			repconvar = "rep_ttt_confirmdelay_delay",
			min = 0,
			max = 1000,
			decimal = 0,
			parent = tttrslst1
		})


		-- add to ULX
		xgui.hookEvent("onProcessModules", nil, tttrspnl.processModules)
		xgui.addSubModule("Confirm Delay", tttrspnl, nil, name)
	end)
end
