local function show_bot_settings(msg)
   local text = '*》Self Bot Settings :《*\n'

   local hash = 'autoleave'
    if not redis:get(hash) then
        autoleave = '[Enable]'
    else
        autoleave = '[Disable]'
    end

   local hash = 'anti-flood'
    if not redis:get(hash) then
        antiflood = '[Enable]'
    else
        antiflood = '[Disable]'
    end

   local hash = 'markread'
    if redis:get(hash) == "on" then
        markread = '[Yes]'
    else
        markread = '[No]'
    end

   local hash = 'flood_max'
    if not redis:get(hash) then
        MSG_NUM_MAX = 5
    else
        MSG_NUM_MAX = tonumber(redis:get(hash))
    end

    local hash = 'flood_time'
    if not redis:get(hash) then
        TIME_CHECK = 2
    else
        TIME_CHECK = tonumber(redis:get(hash))
    end
    local hash = 'mute_gp:'..msg.to.id
    if redis:get(hash) then
        muteall = '[Enable]'
    else
        muteall = '[Disable]'
    end
if msg.to.type == 'channel' then
    text = text..'_》Auto Leave :_ *'..autoleave..'*\n_》Mute All :_ *'..muteall..'*\n_》Messages Read :_ *'..markread..'*\n_》Pv Max Flood :_ *['..MSG_NUM_MAX..']*\n_》Pv Flood Time Check :_ *['..TIME_CHECK..']*\n_》Pv Flood Protection :_ *'..antiflood..'*\n*》*─═ঈঊ(➊)ঊঈ═─*《*'
return edit_msg(msg.to.id, msg.id, text, "md")
elseif msg.to.type == 'pv' or msg.to.type == 'chat' then
    text = text..'_》Auto Leave :_ *'..autoleave..'*\n_》Messages Read :_ *'..markread..'*\n_》Pv Max Flood :_ *['..MSG_NUM_MAX..']*\n_》Pv Flood Time Check :_ *['..TIME_CHECK..']*\n_》Pv Flood Protection :_ *'..antiflood..'*\n*》*─═ঈঊ(➊)ঊঈ═─*《*'
return edit_msg(msg.to.id, msg.id, text, "md")
   end
end

local function disable_channel(msg, receiver)
 if not _config.disabled_channels then
  _config.disabled_channels = {}
 end
 
 _config.disabled_channels[receiver] = true

 save_config()
 return edit_msg(msg.to.id, msg.id, "*سلف خاموش شد*", "md")
end

local function pre_process(msg)
local chat_id = msg.to.id
local user_id = msg.from.id
local hash = 'autoleave' 

if not redis:get('autodeltime-self') then
	redis:setex('autodeltime-self', 14400, true)
     run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
     run_bash("rm -rf ~/.telegram-cli/data/photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/animation/*")
     run_bash("rm -rf ~/.telegram-cli/data/video/*")
     run_bash("rm -rf ~/.telegram-cli/data/audio/*")
     run_bash("rm -rf ~/.telegram-cli/data/voice/*")
     run_bash("rm -rf ~/.telegram-cli/data/temp/*")
     run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
     run_bash("rm -rf ~/.telegram-cli/data/document/*")
     run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
	 run_bash("rm -rf ./data/photos/*")
end

  if msg.from.id then
    local hash = 'user:'..msg.from.id
    if msg.from.username then
     user_name = '@'..msg.from.username
  else
     user_name = msg.from.print_name
    end
      redis:hset(hash, 'user_name', user_name)
  end

if msg.adduser and tonumber(msg.adduser) == tonumber(our_id) and not redis:get(hash) then
 tdcli.sendMessage(msg.to.id, "", 0, "_Don't invite me_ *JackAss :/*", 0, "md")
  tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end

    local hash = 'flood_max'
    if not redis:get(hash) then
        MSG_NUM_MAX = 5
    else
        MSG_NUM_MAX = tonumber(redis:get(hash))
    end

    local hash = 'flood_time'
    if not redis:get(hash) then
        TIME_CHECK = 2
    else
        TIME_CHECK = tonumber(redis:get(hash))
    end
    if msg.to.type == 'pv' then
        --Checking flood
        local hashse = 'anti-flood'
        if not redis:get(hashse) then
            print('anti-flood enabled')
            -- Check flood
                if not is_sudo(msg) then
                    -- Increase the number of messages from the user on the chat
                    local hash = 'flood:'..user_id..':msg-number'
                    local msgs = tonumber(redis:get(hash) or 0)
                    if msgs > MSG_NUM_MAX then
          local flooder = 'flooder'
          local is_offender = redis:sismember(flooder, user_id)
   if msg.from.username then
    user_name = "@"..msg.from.username
       else
    user_name = msg.from.first_name
   end
        if is_offender then
if redis:get('user:'..user_id..':flooder') then
return
else
  tdcli.sendMessage(chat_id, msg.id, 0, "_You are_ *blocked* _because of_ *flooding...!*", 0, "md")
    tdcli.blockUser(user_id, dl_cb, nil)
   tdcli.sendMessage(our_id, 0, 1, 'User [ '..user_name..' ] '..msg.from.id..' has been blocked because of flooding!', 1)
redis:setex('user:'..user_id..':flooder', 15, true)
redis:srem(flooder, user_id)
                        end
                    end
        if not is_offender then
if redis:get('user:'..user_id..':flooder') then
return
else
  tdcli.sendMessage(chat_id, msg.id, 0, "_Don't_ *flooding*, _Next time you will be_ *block...!*", 0, "md")
redis:setex('user:'..user_id..':flooder', 2, true)
redis:sadd(flooder, user_id)
                          end
                       end
                    end
                    redis:setex(hash, TIME_CHECK, msgs+1)
         end
    end
end

   if (is_silented_user(msg.to.id, msg.from.id) or redis:get("mute_gp:"..msg.to.id)) and not is_sudo(msg) then
   del_msg(msg.to.id, msg.id)
  end
-----------------------
end
-------------------
local function run(msg, matches)
local receiver = msg.to.id
	-- Enable a channel
	if not is_sudo(msg) then
	return nil
	end
 if matches[1] == 'on' then
  return enable_channel(receiver)
 end
 if matches[1] == 'off' then
  return disable_channel(msg, receiver)
 end
-----------------------
     if matches[1] == 'autoleave' and is_sudo(msg) then
local hash = 'autoleave'
--Enable Auto Leave
     if matches[2] == 'on' then
     if not redis:get(hash) then
   return edit_msg(msg.to.id, msg.id, 'Auto leave is already enabled', "md")
      else
    redis:del(hash)
   return edit_msg(msg.to.id, msg.id, 'Auto leave has been enabled', "md")
     end
--Disable Auto Leave
     elseif matches[2] == 'off' then
     if redis:get(hash) then
   return edit_msg(msg.to.id, msg.id, 'Auto leave is already disabled', "md")
      else
    redis:set(hash, true)
   return edit_msg(msg.to.id, msg.id, 'Auto leave has been disabled', "md")
         end
      end
   end

     if matches[1] == 'antiflood' and is_sudo(msg) then
local hash = 'anti-flood'
--Enable Anti-flood
     if matches[2] == 'on' then
  if not redis:get(hash) then
    return edit_msg(msg.to.id, msg.id, '_Private_ *flood protection* _is already_ *enabled*', "md")
    else
    redis:del(hash)
   return edit_msg(msg.to.id, msg.id, '_Private_ *flood protection* _has been_ *enabled*', "md")
      end
--Disable Anti-flood
     elseif matches[2] == 'off' then
  if redis:get(hash) then
    return edit_msg(msg.to.id, msg.id, '_Private_ *flood protection* _is already_ *disabled*', "md")
    else
    redis:set(hash, true)
   return edit_msg(msg.to.id, msg.id, '_Private_ *flood protection* _has been_ *disabled*', "md")
                   end
             end
       end
                if matches[1] == 'pvfloodtime' and is_sudo(msg) then
                    if not matches[2] then
                    else
                        hash = 'flood_time'
                        redis:set(hash, matches[2])
            return edit_msg(msg.to.id, msg.id, '_Private_ *flood check time* _has been set to :_ *'..matches[2]..'*', "md")
                    end
          elseif matches[1] == 'pvsetflood' and is_sudo(msg) then
                    if not matches[2] then
                    else
                        hash = 'flood_max'
                        redis:set(hash, matches[2])
            return edit_msg(msg.to.id, msg.id, '_Private_ *flood sensitivity* _has been set to :_ *'..matches[2]..'*', "md")
                    end
                 end

       if matches[1] == 'settings' and is_sudo(msg) then
      return show_bot_settings(msg)
                 end

if matches[1] == 'help' and is_sudo(msg) then

local text = [[
*⌨دستورات:*

*!settings*
_⚙تنظیمات_

*!gpid*
_🔶ایدی  گروه_

*!tosuper*
_🔷تبدیل به سوپر گروه_

*!chatlist*
_🔶نشان دادن اسم ها_

*!chat + name answer*
_🔷تنظیم اسم گروه  و جواب_

*!chat - name*
_🔶غیر فعال کردن چت در (اسم گروه)_

*!chat clean*
_🔷پاک کردن چت و جواب ها_

*!delmy*`[name | username]`
_🔷حذف اسم یا یوزرنیم من_

*!markread* `[on | off]`
_🔶خواندن پیام_

*!autoleave* `[on | off]`
_🔷خروج خودکار_

*!antiflood* `[on | off]`
_🔶حساسیت پیام تکراری_

*!self* `[on | off]`
_🔷ربات در گروه فعال \غیر فعال شود_

*!pin* `(reply)`
_🔶پین کردن پیام در گروه_

*!unpin*
_🔷از پین دراوردن پیام_

*!id* `[reply | username]`
_🔶نشان دادن ایدی عددی_

*!dil* (reply)
_🔷حذف پیام_

*!inv* `[id | username | reply]`
_🔶دعوت کسی به گروه_

*!kick* `[id | username | reply]`
_🔷اخراج کاربر_

*!delall* `[id | username | reply]`
_🔶همه پیام های یک شخص حذف شود_

*!mute* `all`
_🔷گروه بیصدا_

*!unmute* `all`
_🔶فعال کردن گروه_

*!set*`[name | des | link]`
_🔷تنظیم نام گروه , بیو , لینک_

*!addplugin* _text_ `name.lua`
_🔶اضافه کردن پلاگین شما_

*!delplugin* `name`
_🔷حذف پلاگین_

*!setmy*`[name | username]` *(name|username)*
_🔶تنظیم اسم یا یوزر من_

*!addcontact* `[phone | firstname | lastname]`
_🔷اضافه کردن مخاطب_

*!delcontact* `[phone]`
_🔶حذف مخاطب_

*!addname* `[name]`
_🔷اضافه کردن نام به لیست_

*!remname* `[name]`
_🔶حذف یک اسم_

*!setanswer* `[answer]`
_🔷تنظیم یک جواب_

*!remanswer* `[answer]`
_🔶حذف یک جواب_

*!namelist*
_🔷نشان دادن اسم های ذخیره شده_

*!answerlist*
_🔶لیست جواب های ربات_

*!pvsetflood* `[msgs]`
_🔷حد اکثر پیام ارسالی به پیوی_

*!pvfloodtime* `[secs]`
_🔶زمان چک کردن پیام های تکراری در پیوی_

*!block* `[reply | id | username]`
_🔷مسدود کردن کاربر_

*!unblock* `[reply | id | username]`
_🔶از مسدود خارج کن_

*!sendfile* `[folder] [file]`
_🔷ارسال فایل_

*!sendplug* `[plug]`
_🔶ارسال پلاگین_

*!save* `[plugin name] [reply]`
_🔷ذخیره پلاگین_

*!savefile* `[adress/filename] [reply]`
_🔶ذخیر یک فایل با ریپلی_

*!edit* `[text] [reply]`
_🔷ویرایش پیام شما_

*!clear cache*
_🔶پاک کردن پوشه .telegram-cli/data_

*!helpp*
_🔷راهنمای گزینه های اضافی_

*موفق باشید:)*]]

tdcli.sendMessage(msg.sender_user_id_, "", 0, text, 0, "md")
            return edit_msg(msg.to.id, msg.id, '_Help was send in your private message_', "md")
end
end

return {
	description = "Plugin to manage channels. Enable or disable channel.", 
	usage = {
		"/channel enable: enable current channel",
		"/channel disable: disable current channel" },
	patterns = {
     "^[!/#](antiflood) (.*)$",
     "^[!/#](pvfloodtime) (%d+)$",
     "^[!/#](pvsetflood) (%d+)$",
		"^[!/#](autoleave) (.*)$",
		"^[!/#](settings)$",
		"^[!/#](help)$",
		"^[!/][Ss]elf (off)" 
}, 
	run = run,
moderated = true,
	pre_process = pre_process
}
