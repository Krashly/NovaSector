// /obj/item/clothing/glasses/hud/gun_permit
// 	name = "permit HUD"
// 	desc = "A heads-up display that scans humanoids in view, and displays if their current ID possesses a firearms permit or not."
// 	icon = 'modular_nova/modules/company_imports/icons/hud_goggles.dmi'
// 	worn_icon = 'modular_nova/modules/company_imports/icons/hud_goggles_worn.dmi'
// 	icon_state = "permithud"
// 	hud_type = DATA_HUD_PERMIT

// /obj/item/clothing/glasses/hud/gun_permit/sunglasses
// 	name = "permit HUD sunglasses"
// 	desc = "A pair of sunglasses with a heads-up display that scans humanoids in view, and displays if their current ID possesses a firearms permit or not."
// 	flash_protect = FLASH_PROTECTION_FLASH
// 	tint = 1

// /datum/design/permit_hud
// 	name = "Gun Permit HUD glasses"
// 	desc = "A heads-up display that scans humanoids in view, and displays if their current ID possesses a firearms permit or not."
// 	id = "permit_glasses"
// 	build_type = PROTOLATHE | AWAY_LATHE
// 	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5)
// 	build_path = /obj/item/clothing/glasses/hud/gun_permit
// 	category = list(RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC)
// 	departmental_flags = DEPARTMENT_BITFLAG_CARGO
