#define PROGRESSBAR_HEIGHT 6

/datum/progressbar
	var/goal = 1
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client
	var/listindex

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	if(!istype(target))
		target = User
	if(goal_number)
		goal = goal_number
	bar = image('icons/effects/progressbar.dmi', target, "prog_bar_0")
	bar.alpha = 0
	bar.plane = PLANE_PLAYER_HUD
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	user = User
	if(user)
		client = user.client

	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])
	var/list/bars = user.progressbars[bar.loc]
	bars.Add(src)
	listindex = bars.len
	animate(bar, pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = 5, easing = SINE_EASING)

/datum/progressbar/proc/update(progress)
	if(!user || !user.client)
		shown = 0
		return
	if(user.client != client)
		if(client)
			client.images -= bar
		if(user.client)
			user.client.images += bar

	progress = CLAMP(progress, 0, goal)
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if(!shown && user.is_preference_enabled(/datum/client_preference/show_progress_bar))
		user.client.images += bar
		shown = 1

/datum/progressbar/proc/shiftDown()
	--listindex
	var/shiftheight = bar.pixel_y - PROGRESSBAR_HEIGHT
	animate(bar, pixel_y = shiftheight, time = 5, easing = SINE_EASING)

/datum/progressbar/Destroy()
	for(var/datum/progressbar/P as anything in user.progressbars[bar.loc])
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	var/list/bars = user.progressbars[bar.loc]
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.progressbars, bar.loc)
	animate(bar, alpha = 0, time = 5)
	spawn(5)
		if(client)
			client.images -= bar
		//qdel(bar) //ChompEDIT - try not qdelling progressbars.
		bar = null //ChompEDIT - null instead of qdel
	. = ..()

#undef PROGRESSBAR_HEIGHT
