//shows a list of clients we could send PMs to, then forwards our choice to cmd_Mentor_pm
/client/proc/cmd_mentor_pm_panel()
	set category = "Mentor"
	set name = "Mentor PM"
	if(!is_mentor())
		to_chat(src, "<span class='danger'>Error: Mentor-PM-Panel: Only Mentors and Admins may use this command.</span>")
		return
	var/list/client/targets[0]
	for(var/client/T)
		targets["[T]"] = T

	var/list/sorted = sort_list(targets)
	var/target = input(src,"To whom shall we send a message?","Mentor PM",null) in sorted|null
	cmd_mentor_pm(targets[target],null)
	SSblackbox.record_feedback("tally", "Mentor_verb", 1, "APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//takes input from cmd_mentor_pm_context, cmd_Mentor_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_mentor_pm(whom, msg)
	var/client/C
	if(ismob(whom))
		var/mob/M = whom
		C = M.client
	else if(istext(whom))
		C = GLOB.directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(is_mentor())	to_chat(src, "<span class='danger'>Error: Mentor-PM: Client not found.</span>")
		else		mentorhelp(msg)	//Mentor we are replying to left. Mentorhelp instead(check below)
		return

	if(is_mentor(whom))
		to_chat(GLOB.mentors, "<span class='mentor'><font color='purple'>[src] has started replying to [whom]'s mhelp.</font></span>")

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private message") as text|null

		if(!msg)
			if (is_mentor(whom))
				to_chat(GLOB.mentors, "<span class='mentor'><span class='purple'>[src] has stopped their reply to [whom]'s mhelp.</span></span>")
			return

		if(!C)
			if(is_mentor())
				to_chat(src, "<span class='danger'>Error: Mentor-PM: Client not found.</span>")
			else
				mentorhelp(msg)	//Mentor we are replying to has vanished, Mentorhelp instead (how the fuck does this work?let's hope it works,shrug)
				return

		// Neither party is a mentor, they shouldn't be PMing!
		if (!C.is_mentor() && !is_mentor())
			return

	msg = sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN))
	if(!msg)
		if (is_mentor(whom))
			to_chat(GLOB.mentors, "<span class='mentor'><span class='purple'>[src] has stopped their reply to [whom]'s mhelp.</span></span>")
		return
	log_mentor("Mentor PM: [key_name(src)]->[key_name(C)]: [msg]")

	msg = emoji_parse(msg)
	C << 'sound/items/bikehorn.ogg'
	var/show_char = CONFIG_GET(flag/mentors_mobname_only)
	if(C.is_mentor())
		if(is_mentor())//both are mentors
			to_chat(C, "<span class='mentor'><span class='purple'>Mentor PM from-<b>[key_name_mentor(src, C, 1, 0, 0)]</b>: [msg]</span></span>")
			to_chat(src, "<span class='mentor'><span class='blue'>Mentor PM to-<b>[key_name_mentor(C, C, 1, 0, 0)]</b>: [msg]</span></span>")

		else		//recipient is a mentor but sender is not
			to_chat(C, "<span class='mentor'><span class='purple'>Reply PM from-<b>[key_name_mentor(src, C, 1, 0, show_char)]</b>: [msg]</span></span>")
			to_chat(src, "<span class='mentor'><span class='pink'>Mentor PM to-<b>[key_name_mentor(C, C, 1, 0, 0)]</b>: [msg]</span></span>")

	else
		if(is_mentor())	//sender is a mentor but recipient is not.
			to_chat(C, "<span class='mentor'><span class='purple'>Mentor PM from-<b>[key_name_mentor(src, C, 1, 0, 0)]</b>: [msg]</span></span>")
			to_chat(src, "<span class='mentor'><span class='pink'>Mentor PM to-<b>[key_name_mentor(C, C, 1, 0, show_char)]</b>: [msg]</span></span>")

	//we don't use message_Mentors here because the sender/receiver might get it too
	var/show_char_sender = !is_mentor() && CONFIG_GET(flag/mentors_mobname_only)
	var/show_char_recip = !C.is_mentor() && CONFIG_GET(flag/mentors_mobname_only)
	for(var/it in GLOB.mentors)
		var/client/X = it
		if(X.key!=key && X.key!=C.key)	//check client/X is an Mentor and isn't the sender or recipient
			to_chat(X, "<span class='mentor'><B><span class='pink'>Mentor PM: [key_name_mentor(src, X, 0, 0, show_char_sender)]-&gt;[key_name_mentor(C, X, 0, 0, show_char_recip)]:</span></B> <span class='blue'>[msg]</span></span>") //inform X
