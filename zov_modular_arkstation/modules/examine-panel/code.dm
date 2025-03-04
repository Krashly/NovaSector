/datum/examine_panel/ui_data(mob/user)
	var/list/data = ..()
	var/datum/preferences/preferences = holder.client?.prefs
	var/flavor_text_nsfw = ""
	var/headshot_nsfw = ""
	var/character_ad = ""
	var/emote_length = preferences?.read_preference(/datum/preference/choiced/emote_length)
	var/approach = preferences?.read_preference(/datum/preference/choiced/approach_pref)
	var/furries = preferences?.read_preference(/datum/preference/choiced/furry_pref)
	var/scalies = preferences?.read_preference(/datum/preference/choiced/scalie_pref)
	var/others = preferences?.read_preference(/datum/preference/choiced/other_pref)
	var/demihumans = preferences?.read_preference(/datum/preference/choiced/demihuman_pref)
	var/humans = preferences?.read_preference(/datum/preference/choiced/human_pref)
	var/show_nsfw_flavor_text = preferences?.read_preference(/datum/preference/choiced/show_nsfw_flavor_text)
	if(issilicon(holder) && !(show_nsfw_flavor_text == "Never"))
		flavor_text_nsfw = preferences?.read_preference(/datum/preference/text/flavor_text_nsfw/silicon)
		headshot_nsfw += preferences?.read_preference(/datum/preference/text/headshot/silicon/nsfw)
	if(ishuman(holder))
		var/mob/living/carbon/human/holder_human = holder
		if((show_nsfw_flavor_text == "Always On") || (show_nsfw_flavor_text == "Nude Only" && !(holder_human.w_uniform)))
			flavor_text_nsfw = preferences?.read_preference(/datum/preference/text/flavor_text_nsfw)
			headshot_nsfw += preferences?.read_preference(/datum/preference/text/headshot/nsfw)
	character_ad += "Preferred Emote Length: [emote_length]\n"
	character_ad += "How to Approach: [approach]\n"
	character_ad += "Furries: [furries] | Scalies: [scalies] | Other: [others]\n"
	character_ad += "Demis: [demihumans] | Humans: [humans]\n"
	character_ad += "\n"
	character_ad += preferences?.read_preference(/datum/preference/text/character_ad)

	data["character_ad"] = character_ad
	data["flavor_text_nsfw"] = flavor_text_nsfw
	data["headshot_nsfw"] = headshot_nsfw
	return data

//

/datum/preferences
	var/headshot_nsfw = ""
	var/headshot_silicon = ""
	var/headshot_silicon_nsfw = ""

/datum/preference/text/flavor_text_nsfw
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flavor_text_nsfw"
	maximum_value_length = MAX_FLAVOR_LEN

//We want to make sure this is empty by default.
/datum/preference/text/flavor_text_nsfw/create_default_value()
	return ""

/datum/preference/text/flavor_text_nsfw/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

//This is just a silicon variant of the NSFW flavor text.
/datum/preference/text/flavor_text_nsfw/silicon
	savefile_key = "silicon_flavor_text_nsfw"

//Lets the client choose when their NSFW flavor text is visible on a per-character basis.
/datum/preference/choiced/show_nsfw_flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "show_flavor_text_nsfw"

/datum/preference/choiced/show_nsfw_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

//These are our options for when NSFW flavor text is shown. Always On = Always Visible, Nude Only means only when they are not wearing a uniform, and Never means it is never visible.
//These can be changed by clients on the fly.
/datum/preference/choiced/show_nsfw_flavor_text/init_possible_values()
	return list("Always On", "Nude Only", "Never")

/datum/preference/choiced/show_nsfw_flavor_text/create_default_value()
	return "Nude Only"

//NSFW headshot, so we can see those they/them nuts in the NSFW section of the character creator.
//TODO: Move the headshot proc over here so they stop overwriting each other by being a subtype.
/datum/preference/text/headshot/nsfw
	savefile_key = "headshot_nsfw"

/datum/preference/text/headshot/nsfw/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/headshot/nsfw/apply_headshot(value)
	if(stored_link[usr.ckey] != value)
		log_game("[usr] has set their NSFW Headshot image to '[value]'.")
	stored_link[usr?.ckey] = value
	usr?.client?.prefs.headshot_nsfw = value

//This is literally just the same as the original headshot pref but for silicons :)
/datum/preference/text/headshot/silicon
	savefile_key = "headshot_silicon"

/datum/preference/text/headshot/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/headshot/silicon/apply_headshot(value)
	if(stored_link[usr.ckey] != value)
		to_chat(usr, span_notice("Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Think of it as a headshot for your ID. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
		log_game("[usr] has set their Silicon Headshot image to '[value]'.")
	stored_link[usr?.ckey] = value
	usr?.client?.prefs.headshot_silicon = value

//Same as the original NSFW headshot pref, but for silicons.
/datum/preference/text/headshot/silicon/nsfw
	savefile_key = "headshot_silicon_nsfw"

/datum/preference/text/headshot/silicon/nsfw/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/headshot/silicon/nsfw/apply_headshot(value)
	if(stored_link[usr.ckey] != value)
		log_game("[usr] has set their NSFW Silicon Headshot image to '[value]'.")
	stored_link[usr?.ckey] = value
	usr?.client?.prefs.headshot_silicon_nsfw = value

//OOC notes for Silicons. Overwrites regular OOC notes when you are playing a Silicon character.
//TODO: Make this your regular OOC notes if you don't have Silicon ones. Every time I've tried, for some reason regular OOC notes haven't shown.
/datum/preference/text/ooc_notes/silicon
	savefile_key = "ooc_notes_silicon"

/datum/preference/text/ooc_notes/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

//Custom species and lore for silicons, also known as "Custom Model." This allows silicons to define a custom species rather than receiving, by default "A cyborg unit." BORING.
/datum/preference/text/custom_species/silicon
	savefile_key = "custom_species_silicon"

/datum/preference/text/custom_species/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/custom_species_lore/silicon
	savefile_key = "custom_species_lore_silicon"

/datum/preference/text/custom_species_lore/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

//Config entry for the Silicon flavor text requirement
/datum/config_entry/number/silicon_flavor_text_character_requirement
	default = 150

//

GLOBAL_DATUM(character_directory, /datum/character_directory)
#define READ_PREFS(target, pref) (target.client.prefs.read_preference(/datum/preference/pref) || "Unset")

//We want players to be able to decide whether they show up in the directory or not
/datum/preference/toggle/show_in_directory
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "show_in_directory"
	savefile_identifier = PREFERENCE_PLAYER

//The advertisement that you show to people looking through the directory
/datum/preference/text/character_ad
	savefile_key = "character_ad"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	maximum_value_length = MAX_FLAVOR_LEN

//TGUI gets angry if you don't define a default on text preferences
/datum/preference/text/character_ad/create_default_value()
	return ""

//Any text preference needs this for some reason
/datum/preference/text/character_ad/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/attraction
	savefile_key = "attraction"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/attraction/init_possible_values()
	return list("Gay", "Lesbian", "Straight", "Skolio", "Bi", "Pan", "Poly", "Omni", "Ace", "Aro", "Aro/Ace", "Unset", "Check OOC")

/datum/preference/choiced/attraction/create_default_value()
	return "Unset"

/datum/preference/choiced/attraction/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/display_gender
	savefile_key = "display_gender"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/display_gender/init_possible_values()
	return list("Male", "Female", "Null", "Plural", "Nonbinary", "Omni", "Trans", "Andro", "Gyno", "Fluid", "Unset", "Check OOC")

/datum/preference/choiced/display_gender/create_default_value()
	return "Unset"

/datum/preference/choiced/display_gender/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE
//Can't believe ARK STATIONstation invented attraction and gender in the year December 2023

/datum/preference/choiced/emote_length
	savefile_key = "emote_length"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/emote_length/init_possible_values()
	return list("A few sentences", "1-2 Paragraphs", "Multi-Paragraph", "I'll Match You", "No Preference", "Check OOC")

/datum/preference/choiced/emote_length/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/emote_length/create_default_value()
	return "No Preference"

/datum/preference/choiced/approach_pref
	savefile_key = "approach_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/approach_pref/init_possible_values()
	return list("Approach IC", "Approach OOC", "Any", "Both", "Check OOC", "See Below", "Unset")

/datum/preference/choiced/approach_pref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/approach_pref/create_default_value()
	return "Unset"

/datum/preference/choiced/furry_pref
	savefile_key = "furry_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/furry_pref/init_possible_values()
	return list("Yes", "No", "No ERP", "Check OOC", "Unset", "Maybe")

/datum/preference/choiced/furry_pref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/furry_pref/create_default_value()
	return "Unset"

/datum/preference/choiced/scalie_pref
	savefile_key = "scalie_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/scalie_pref/init_possible_values()
	return list("Yes", "No", "No ERP", "Check OOC", "Maybe", "Unset")

/datum/preference/choiced/scalie_pref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/scalie_pref/create_default_value()
	return "Unset"

/datum/preference/choiced/other_pref
	savefile_key = "other_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/other_pref/init_possible_values()
	return list("Yes", "No", "No ERP", "Check OOC", "Maybe", "Unset")

/datum/preference/choiced/other_pref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/scalie_pref/create_default_value()
	return "Unset"

/datum/preference/choiced/demihuman_pref
	savefile_key = "demihuman_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/demihuman_pref/init_possible_values()
	return list("Yes", "No", "No ERP", "Check OOC", "Unset", "Maybe")

/datum/preference/choiced/demihuman_pref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/demihuman_pref/create_default_value()
	return "Unset"

/datum/preference/choiced/human_pref
	savefile_key = "human_pref"
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/human_pref/init_possible_values()
	return list("Yes", "No", "No ERP", "Check OOC", "Unset", "Maybe")

/datum/preference/choiced/human_pref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/human_pref/create_default_value()
	return "Unset"

//CHARACTER DIRECTORY CODE START
//Add a cooldown for the character directory to the client, primarily to stop server lag from refresh spam
/client
	COOLDOWN_DECLARE(char_directory_cooldown)

//Make a verb to open the character directory
/client/verb/show_character_directory()
	set name = "Character Directory"
	set category = "OOC"
	set desc = "Shows a listing of all active characters, along with their associated OOC notes, flavor text, and more."

	// This is primarily to stop malicious users from trying to lag the server by spamming this verb
	if(!COOLDOWN_FINISHED(src, char_directory_cooldown))
		to_chat(src, span_alert("Hold your horses! It's still refreshing!"))
		return
	COOLDOWN_START(src, char_directory_cooldown, 10)

//Check if there's not already a character directory open; open a new one if one is not present
	if(!GLOB.character_directory)
		GLOB.character_directory = new
	GLOB.character_directory.ui_interact(mob)

// This is a global singleton. Keep in mind that all operations should occur on user, not src.
/datum/character_directory

/datum/character_directory/ui_state(mob/user)
	return GLOB.always_state

/datum/character_directory/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ZubbersCharacterDirectory", "Character Directory")
		ui.open()

//We want this information to update any time the player updates their preferences, not just when the panel is refreshed
/datum/character_directory/ui_data(mob/user)
	. = ..()
	var/list/data = .

//Collect the user's own preferences for the top of the UI
	if (user?.client?.prefs)
		data["personalVisibility"] = READ_PREFS(user, toggle/show_in_directory)
		data["personalAttraction"] = READ_PREFS(user, choiced/attraction)
		data["personalGender"] = READ_PREFS(user, choiced/display_gender)
		data["personalErpTag"] = READ_PREFS(user, choiced/erp_status)
		data["personalVoreTag"] = READ_PREFS(user, choiced/erp_status_v)
		data["personalHypnoTag"] = READ_PREFS(user, choiced/erp_status_hypno)
		data["personalNonconTag"] = READ_PREFS(user, choiced/erp_status_nc)
		data["prefsOnly"] = TRUE

	data["canOrbit"] = isobserver(user)

	return data

/datum/character_directory/ui_static_data(mob/user)
	. = ..()
	var/list/data = .

	var/list/directory_mobs = list()
	//We want the directory to display only alive players, not observers or people in the lobby
	for(var/mob/mob in GLOB.alive_player_list)
		// These are the variables we're trying to display in the directory
		var/name = ""
		var/species = "Ask"
		var/ooc_notes = ""
		var/flavor_text = ""
		var/nsfw_flavor_text = ""
		var/attraction = "Unset"
		var/gender = "Nonbinary"
		var/erp = "Ask"
		var/vore = "Ask"
		var/hypno = "Ask"
		var/noncon = "Ask"
		var/character_ad = ""
		var/exploitable = ""
		var/ref = REF(mob)
		//Just in case something we get is not a mob
		if(!mob)
			continue

		//Different approach for humans and silicons
		if(ishuman(mob))
			var/mob/living/carbon/human/human = mob
			//If someone is obscured without flavor text visible, we don't want them on the Directory.
			if((human.wear_mask && (human.wear_mask.flags_inv & HIDEFACE) && READ_PREFS(human, toggle/obscurity_examine)) || (human.head && (human.head.flags_inv & HIDEFACE) && READ_PREFS(human, toggle/obscurity_examine)) || (HAS_TRAIT(human, TRAIT_UNKNOWN)))
				continue
			//Display custom species, otherwise show base species instead
			species = (READ_PREFS(human, text/custom_species))
			if(species == "Unset")
				species = "[human.dna.species.name]"
			//Load standard flavor text preference
			flavor_text = READ_PREFS(human, text/flavor_text)
			if((READ_PREFS(human, choiced/show_nsfw_flavor_text) == "Always On") || ((READ_PREFS(human, choiced/show_nsfw_flavor_text) == "Nude Only") && !(human.w_uniform)))
				nsfw_flavor_text = READ_PREFS(human, text/flavor_text_nsfw)
			else nsfw_flavor_text = "Unavailable"

		else if(issilicon(mob))
			var/mob/living/silicon/silicon = mob
			//If the target is a silicon, we want it to show its brain as its species
			species = READ_PREFS(silicon, choiced/brain_type)
			//Load silicon flavor text in place of normal flavor text
			flavor_text = READ_PREFS(silicon, text/silicon_flavor_text)
			if(READ_PREFS(silicon, choiced/show_nsfw_flavor_text) != "Never")
				nsfw_flavor_text = READ_PREFS(silicon, text/flavor_text_nsfw/silicon)
			else nsfw_flavor_text = "Unavailable"
		//Don't show if they are not a human or a silicon
		else continue
		//List of all the shown ERP preferences in the Directory. If there is none, return "Unset"
		attraction = READ_PREFS(mob, choiced/attraction)
		gender = READ_PREFS(mob, choiced/display_gender)
		erp = READ_PREFS(mob, choiced/erp_status)
		vore = READ_PREFS(mob, choiced/erp_status_v)
		hypno = READ_PREFS(mob, choiced/erp_status_hypno)
		noncon = READ_PREFS(mob, choiced/erp_status_nc)
		character_ad = READ_PREFS(mob, text/character_ad)
		ooc_notes = READ_PREFS(mob, text/ooc_notes)
		//If the user is an antagonist or Observer, we want them to be able to see exploitables in the Directory.
		if(user.mind?.has_antag_datum(/datum/antagonist) || isobserver(user))
			if(exploitable == EXPLOITABLE_DEFAULT_TEXT)
				exploitable = "Unset"
			else exploitable = READ_PREFS(mob, text/exploitable)
		else exploitable = "Obscured"
		//And finally, we want to get the mob's name, taking into account disguised names.
		name = mob.real_name ? mob.name : mob.real_name

		directory_mobs.Add(list(list(
			"name" = name,
			"species" = species,
			"ooc_notes" = ooc_notes,
			"attraction" = attraction,
			"gender" = gender,
			"erp" = erp,
			"vore" = vore,
			"hypno" = hypno,
			"noncon" = noncon,
			"exploitable" = exploitable,
			"character_ad" = character_ad,
			"flavor_text" = flavor_text,
			"nsfw_flavor_text" = nsfw_flavor_text,
			"ref" = ref
		)))

	data["directory"] = directory_mobs

	return data

/datum/character_directory/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	var/mob/user = usr
	if(!user)
		return

	switch(action)
		if("refresh")
			// This is primarily to stop malicious users from trying to lag the server by spamming this verb
			if(!COOLDOWN_FINISHED(user.client, char_directory_cooldown))
				to_chat(user, "<span class='warning'>Don't spam character directory refresh.</span>")
				return
			COOLDOWN_START(user.client, char_directory_cooldown, 10)
			update_static_data(user, ui)
			return TRUE
		if("orbit")
			var/ref = params["ref"]
			var/mob/dead/observer/ghost = user
			var/atom/movable/poi = (locate(ref) in GLOB.mob_list)
			if (poi == null)
				return TRUE
			ghost.ManualFollow(poi)
			ghost.reset_perspective(null)
			return TRUE
		if("view")
			var/ref = params["ref"]
			var/datum/examine_panel/panel
			var/mob/living/carbon/target = (locate(ref) in GLOB.mob_list)
			if(issilicon(target))
				var/mob/living/silicon/robot/typed_target = target
				panel = typed_target.examine_panel
				panel.holder = typed_target
			else
				var/mob/living/carbon/human/typed_target = target
				panel = typed_target.tgui
				panel.holder = typed_target
			panel.ui_interact(user)

//

/datum/preference/toggle/obscurity_examine
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "obscurity_examine_pref"
	savefile_identifier = PREFERENCE_PLAYER
