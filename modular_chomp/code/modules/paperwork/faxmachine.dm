/proc/get_role_request_channel()
	var/channel_tag
	if(config.role_request_channel_tag)
		channel_tag = config.role_request_channel_tag

	var/datum/tgs_api/v5/api = TGS_READ_GLOBAL(tgs)
	if(istype(api) && channel_tag)
		for(var/datum/tgs_chat_channel/channel in api.chat_channels)
			if(channel.custom_tag == channel_tag)
				return list(channel)
	return 0

/proc/role_request_discord_message(var/message)
	if(!message)
		return
	var/datum/tgs_chat_channel/channel = get_role_request_channel()
	if(channel)
		world.TgsChatBroadcast(message,channel)

/proc/get_fax_channel()
	var/channel_tag
	if(config.fax_channel_tag)
		channel_tag = config.fax_channel_tag

	var/datum/tgs_api/v5/api = TGS_READ_GLOBAL(tgs)
	if(istype(api) && channel_tag)
		for(var/datum/tgs_chat_channel/channel in api.chat_channels)
			if(channel.custom_tag == channel_tag)
				return list(channel)
	return 0

/proc/fax_discord_message(var/message)
	if(!message)
		return
	var/datum/tgs_chat_channel/channel = get_fax_channel()
	if(channel)
		world.TgsChatBroadcast(message,channel)

/proc/get_discord_role_id_from_department(var/department)
	switch(department)
		if("Command")
			if(config.role_request_id_command)
				return config.role_request_id_command

		if("Security")
			if(config.role_request_id_security)
				return config.role_request_id_security

		if("Engineering")
			if(config.role_request_id_engineering)
				return config.role_request_id_engineering

		if("Medical")
			if(config.role_request_id_medical)
				return config.role_request_id_medical

		if("Research")
			if(config.role_request_id_research)
				return config.role_request_id_research

		if("Supply")
			if(config.role_request_id_supply)
				return config.role_request_id_supply

		if("Service")
			if(config.role_request_id_service)
				return config.role_request_id_service

		if("Expedition")
			if(config.role_request_id_expedition)
				return config.role_request_id_expedition

		if("Silicon")
			if(config.role_request_id_silicon)
				return config.role_request_id_silicon

	return FALSE


/obj/machinery/photocopier/faxmachine/message_chat_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/faxid, font_colour="#006100")
	fax_discord_message("A fax; '[faxname]' was sent.\nSender: [sender.name]\nFax name: [sent.name]\nFax ID: **[faxid]**")


/obj/machinery/photocopier/faxmachine/message_chat_rolerequest(var/font_colour="#006100", var/role_to_ping, var/reason, var/jobname)
	var/roleid = get_discord_role_id_from_department(role_to_ping)

	if(roleid)
		role_request_discord_message("An automated request for crew has been made.\nJob: [jobname]\nReason: [reason]\n\n<@&[roleid]>")
	else
		role_request_discord_message("An automated request for crew has been made.\nJob: [jobname]\nReason: [reason]")