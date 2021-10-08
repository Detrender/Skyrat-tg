/datum/examine_panel
	var/mob/living/carbon/human/holder //client of whoever is using this datum
	var/mob/living/carbon/human/dummy/dummy_holder
	var/atom/movable/screen/examine_panel_dummy/examine_panel_screen

/datum/examine_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/examine_panel/ui_close(mob/user)
	user.client.clear_map(examine_panel_screen.assigned_map)

/atom/movable/screen/examine_panel_dummy
	name = "examine panel dummy"

/datum/examine_panel/ui_interact(mob/user, datum/tgui/ui)
	if(!examine_panel_screen)
		dummy_holder = generate_dummy_lookalike(REF(holder), holder)
		var/datum/job/job_ref = SSjob.GetJob(holder.job)
		if(job_ref && job_ref.outfit)
			var/datum/outfit/outfit_ref = new()
			outfit_ref.copy_outfit_from_target(holder)
			outfit_ref.equip(dummy_holder, visualsOnly=TRUE)
		examine_panel_screen = new
		examine_panel_screen.vis_contents += dummy_holder
		examine_panel_screen.name = "screen"
		examine_panel_screen.assigned_map = "examine_panel_[REF(holder)]_map"
		examine_panel_screen.del_on_map_removal = FALSE
		examine_panel_screen.screen_loc = "[examine_panel_screen.assigned_map]:1,1"
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(examine_panel_screen)
		ui = new(user, src, "ExaminePanel")
		ui.open()

/datum/examine_panel/ui_data(mob/user)
	var/list/data = list()

	var/datum/preferences/preferences = holder.client?.prefs

	var/skipface = (holder.wear_mask && (holder.wear_mask.flags_inv & HIDEFACE)) || (holder.head && (holder.head.flags_inv & HIDEFACE))
	var/name = skipface ? "Unknown" : holder.name
	var/flavor_text = skipface ? "Obscured" :  holder.dna.features["flavor_text"]
	var/custom_species = skipface ? "Obscured" : holder.dna.features["custom_species"]
	var/custom_species_lore = skipface ? "Obscured" : holder.dna.features["custom_species_lore"]

	var/e_prefs
	var/e_prefs_nc
	var/list/ooc_notes = list()

	if(preferences)
		e_prefs = preferences.read_preference(/datum/preference/choiced/erp_status)
		e_prefs_nc = preferences.read_preference(/datum/preference/choiced/erp_status_nc)
		ooc_notes += "ERP PREFERENCES: ERP - [e_prefs] | Noncon - [e_prefs_nc] <br>"

	ooc_notes += holder.dna.features["ooc_notes"]

	data["obscured"] = skipface ? TRUE : FALSE
	data["character_name"] = name
	data["assigned_map"] = examine_panel_screen.assigned_map
	data["flavor_text"] = flavor_text
	data["ooc_notes"] = ooc_notes
	data["custom_species"] = custom_species
	data["custom_species_lore"] = custom_species_lore
	return data
