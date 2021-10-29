/datum/outfit/centcom/ert/gcc
	name = "Gilgamesh Colonial Confederation Soldier"

	head = /obj/item/clothing/head/helmet/rus_helmet/gcc
	glasses = /obj/item/clothing/glasses/night
	ears = /obj/item/radio/headset/headset_cent/alt/with_key
	mask = /obj/item/clothing/mask/balaclavaadjust
	uniform = /obj/item/clothing/under/costume/gcc
	suit = /obj/item/clothing/suit/armor/vest/russian/gcc
	suit_store = /obj/item/gun/ballistic/automatic/assault_rifle/akm
	gloves = /obj/item/clothing/gloves/combat
	belt = /obj/item/storage/belt/military/gcc/full
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/storage/box/gcc_survival_pack, /obj/item/clothing/mask/gas/alt)
	shoes = /obj/item/clothing/shoes/jackboots/black

	id = /obj/item/card/id/advanced/centcom/ert/gcc
	id_trim = /datum/id_trim/gcc

/datum/outfit/centcom/ert/gcc/heavy
	name = "Gilgamesh Colonial Confederation Heavy Soldier"
	head = /obj/item/clothing/head/helmet/gcc_heavy
	suit = /obj/item/clothing/suit/armor/heavy/gcc
	mask = /obj/item/clothing/mask/gas/alt

	back = /obj/item/deployable_turret_folded
	backpack_contents = null

	l_pocket = /obj/item/wrench/combat

	id_trim = /datum/id_trim/gcc/heavy

/datum/outfit/centcom/ert/gcc/commander
	name = "Gilgamesh Colonial Confederation Platoon Commander"
	head = /obj/item/clothing/head/beret/sec/gcc

	id_trim = /datum/id_trim/gcc/commander
