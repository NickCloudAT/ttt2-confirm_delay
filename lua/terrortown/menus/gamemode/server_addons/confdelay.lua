CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_confdelay_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_addons_confdelay")

	form:MakeHelp({
		label = "help_confdelay_menu"
	})

	local masterCB = form:MakeCheckBox({
		label = "label_confdelay_enabled",
		serverConvar = "ttt_confirmdelay_enable"
	})

	form:MakeCheckBox({
		label = "label_confdelay_dete_bypass",
		serverConvar = "ttt_confirmdelay_detective_bypass",
		master = masterCB
	})

	form:MakeSlider({
		label = "label_confdelay_delay",
		serverConvar = "ttt_confirmdelay_delay",
		min = 0,
		max = 100,
		decimal = 1,
		master = masterCB
	})
end
