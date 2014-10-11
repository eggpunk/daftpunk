#Dekadent Learn v1.0.1 by CoolMaster for eggdrop - PLEASE DON'T UNCOMMENT(removing the "#") THE COMMENTED LINES
#
######## INFO(it's important to read the all info and configuration to learn how to use this script) ########
#This eggdrop TCL Script is an advanced learn script, all importat things
#are customizable (files, triggers, flags, and many other).
#This script saves/stores the learn entrys in files, and has possibility to saves/stores infinit
#definitions to just one word. Because this script uses just one file to save/store entrys it's possible that
#could be a bit more slower but i prefer this method.
#I won't talk about all features because you have the detailed explanation of all listened on configuration.
#Ok i'm far away to be an expert on TCL Scripting. I made this to improve my skills and *learn* more things
#about TCL.
#This Script was tested in eggdrop 1.6.3 but should work on lower versions.
#
#IMPORTANT: please don't use the character "¦" on definitions because that character is used to separate
# definitions of word, i think that the maiority of people never use it but...
# I recomend that never use a non-alphanumeric character to learn words.
# Some special characters maybe be enclosed by {} an example is ";" will be "{;}".
#
#I'm tired to explain to all people that the TCL Scripting was not born because eggdrop, the eggdrop coders
#adopted that kind of Scripting to help users to develop their *guddies* to eggdrop. I'm telling this
#because most of people thinks that the TCL is only for eggdrop and it's very wrong, because TCL it's a good
#advanced scripting language to all plataforms developing utilities.
#
#Send your comments/flamez/sugestions to coolmaster@GameOver.co.pt or in Learn WebSite <http://coolmaster.cjb.net>
#You can visit me on irc.PTlink.net then #PST (http://scripters.ptlink.net)
#
#This Script is distributed under the TERMS of GNU General Public Licence(GPL) if you don't have
#the terms of GPL please go to http://www.bubix.net/~coolmaster/GPL.txt
#
#This script is dedicated to all *Dekadent* people arround the world, if you find any bug please report it
#to me.
#
#
#
#
#ChangeLog
# *Version 1.0b - 27/12/2001*
#  FIRST RELEASE
#
# *Version 1.0 - 28/12/2001*
#  FIRST PUBLIC RELEASE
# 1. Fixed bug when use some characters at the end of definition, i fixed this with one *trick* puting space
#  to the end of definition, tks to kil because i found it when he add a word and to Lamego that tells me
#  that the prob. is with space.
# 2. Chaged "puthelp" to "putserv" because in my tests the putserv allways be the faster.
# 3. Added binds to learn work under private msgs and a new proc to view definition trough private msg request.
# 4. The $chan variable is now converted to lower case letters to avoid case sensitive letters on exempt channels.
#
# *Version 1.0.1 - 01/13/02*
# 1. If learn or lock file does not exist the script will atempt to create them. If some error happen on
#  partyline when the script try to create the files you will be warned and please give to directory of learn
#  files, +rw permission, if the directory is on eggdrop dir you should not have problems.
# 2. Minor changes.


############# Configuration (i think this actual configuration is very good but you can change it)###########


## Files & Backup time (note: never give the same name to the files or the script will make the bot die ##
 #Don't forget, all this files need to have +rw permissions you can do that with chmod command.

#The file to store learn data
set learn(file) "learn.dat"

#The file to backup the data
set learn(backupfile) "learn.dat.old"

#The file where the lock definitions will be stored/saved
set learn(lockfile) "learn.lock.dat"

#The temp file when you need to delete/insert something or add/delete words of lock file
set learn(tempfile) "learn.tmp"

#The time in minutes between each backup, '0' for no backup usage but you can manualy force backup to be saved.
set learn(backuptime) "480"


## Triggers ##


#To add a definition to a word --> trigger <word> <definition>
set learn(add) "!+"

#To delete all word --> trigger <word>
set learn(forget) "!forget"

#To insert a definition to word, the definition will be added to the end --> trigger <word> <definition>
set learn(insert) "!++"

#To delete one definition from word --> trigger <word> <n>
set learn(del) "!-"

#To lock one word, if word is locked it's impossible insert/delete that word --> trigger <word>
set learn(lock) "!lock"

#This will unlock a locked word --> trigger <word>
set learn(unlock) "!unlock"

#This is used to retrieve a definition of word --> ?? <word>
set learn(view) "??"

#The list of words in learn file
set learn(wordlist) "!learnlist"

#This is used to see the lock words
set learn(lockwords) "!locklist"

#This is the trigger to force backup to be saved
set learn(forcebackup) "!forceback"

#This is the trigger to show some misc info
set learn(misc) "!learninfo"

#The help with all triggers and other misc stuff. This will change consoant if you have or not permission to change the data.
set learn(help) "!lhelp"



## Misc ##

#The flag needed add/insert/delete one definition/delete word
set learn(flags-change) "o"

#The flag needed to lock/unlock a word and even to force backup to be saved, i recomend and it's logical
# never give less access than the flags-change
set learn(owner) "m"

#This is the method PRIVMSG/NOTICE when something changed this will work only for the nick who change
set learn(method) "NOTICE"

#This is the method PRIVMSG/NOTICE when you try to retrieve a definition, this will be sended to a target request(channel/nick)
set learn(method-def) "PRIVMSG"

#This is the exempt channels to the bot separated by commas(,)
set learn(non-channels) ""




############# Don't change nothing below if you don't know what you are doing ###############


## BINDS ##
bind pub - $learn(add) learn_add
bind pub - $learn(forget) learn_forget
bind pub - $learn(lock) learn_lock
bind pub - $learn(unlock) learn_unlock
bind pub - $learn(insert) learn_insert
bind pub - $learn(del) learn_del
bind pub - $learn(view) learn_view
bind pub - $learn(forcebackup) learn_forceback
bind pub - $learn(lockwords) learn_lockwords
bind pub - $learn(wordlist) learn_list
bind pub - $learn(misc) learn_misc
bind pub - $learn(help) learn_help

bind msg - $learn(add) learn_add
bind msg - $learn(forget) learn_forget
bind msg - $learn(lock) learn_lock
bind msg - $learn(unlock) learn_unlock
bind msg - $learn(insert) learn_insert
bind msg - $learn(del) learn_del
bind msg - $learn(view) learn_view_msg
bind msg - $learn(forcebackup) learn_forceback
bind msg - $learn(lockwords) learn_lockwords
bind msg - $learn(wordlist) learn_list
bind msg - $learn(misc) learn_misc
bind msg - $learn(help) learn_help



## Misc ##
set learn(version) "v1.0.1"
putlog "Dekadent Learn $learn(version) by CoolMaster <coolmaster@GameOver.co.pt> <http://coolmaster.cjb.net>"
if {$learn(backuptime) > 0} {timer $learn(backuptime) learn_backup}
if {[string compare $learn(file) $learn(backupfile)] == 0} {die "Dekadent Learn, you probably have the same name to other types of file, please edit your Dekadent Learn"}
if {[string compare $learn(file) $learn(lockfile)] == 0} {die "Dekadent Learn, you probably have the same name to other types of file, please edit your Dekadent Learn"}
if {[string compare $learn(file) $learn(tempfile)] == 0} {die "Dekadent Learn, you probably have the same name to other types of file, please edit your Dekadent Learn"}
if {[string compare $learn(backupfile) $learn(lockfile)] == 0} {die "Dekadent Learn, you probably have the same name to other types of file, please edit your Dekadent Learn"}
if {[string compare $learn(backupfile) $learn(tempfile)] == 0} {die "Dekadent Learn, you probably have the same name to other types of file, please edit your Dekadent Learn"}
if {[string compare $learn(tempfile) $learn(lockfile)] == 0} {die "Dekadent Learn, you probably have the same name to other types of file, please edit your Dekadent Learn"}
if {![file exists $learn(file)]} {set fxtmp [open $learn(file) w] ; close $fxtmp}
if {![file exists $learn(lockfile)]} {set fxtmp [open $learn(lockfile) w] ; close $fxtmp}


## Procs ##


#This will check if word is locked, if is return 1 else return 2
proc check_lock {word} {
global learn
set fx [open $learn(lockfile) r]
while {![eof $fx]} {
set word_check [gets $fx]
if {[string compare $word $word_check] == 0} {close $fx ; return 1}
}
close $fx ; return 2
}



# Verify if user have access flags to use learn changes, return 1 if yes else return 2
proc check_access {hand type} {
global learn
if {[matchattr $hand $learn($type)] == 1} {return 1} else {return 2}
}


# Verify if definition allready exists, if yes will return 1 else return 2
proc check_word {word} {
global learn
set fx [open $learn(file) r]
while {![eof $fx]} {
set word_check [lindex [gets $fx] 0]
if {[string compare $word $word_check] == 0} {close $fx ; return 1}
}
close $fx ; return 2
}


# Verify if channel is not on exempt list, if is return 1 else return 2
proc isvalidchan {chan} {
global learn
set chans [string tolower [split "$learn(non-channels)" ","]]
set i 0
while {1} {
set chan_c [lindex $chans $i]
if {$chan_c == ""} {return 2} elseif {$chan_c == "$chan"} {return 1}
incr i 1
}
}


proc learn_add {nick host hand chan text} {
global learn
if {[check_access $hand flags-change] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
set word [string tolower [lindex $text 0]]
set definition [lrange $text 1 end]
if {$definition == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(add) <word> <definition>"
return 0
}
if {[check_word $word] == 1} {
putserv "$learn(method) $nick :Definition allready exists"
return 0
}
set fx [open $learn(file) a]
puts $fx "$word $definition "
close $fx
putserv "$learn(method) $nick :Added \"$word\" to database"
}


proc learn_forget {nick host hand chan text} {
global learn
if {[check_access $hand flags-change] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
set word [string tolower [lindex $text 0]]
if {$word == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(forget) <word>"
return 0
}
if {[check_word $word] == 2} {
putserv "$learn(method) $nick :Unable to delete, definition not found"
return 0
}
if {[check_lock $word] == 1} {
putserv "$learn(method) $nick :Unable to delete, definition is locked"
return 0
}
set fx1 [open $learn(file) r]
set fx2 [open $learn(tempfile) w]
while {![eof $fx1]} {
set tmp [gets $fx1]
set word_check [lindex $tmp 0]
if {$tmp != ""} {if {[string compare $word $word_check] == 0} {continue} else {puts $fx2 $tmp}}
}
close $fx1 ; close $fx2
exec rm -f $learn(file) ; exec mv $learn(tempfile) $learn(file)
putserv "$learn(method) $nick :\"$word\" deleted from database"
}


proc learn_list {nick host hand chan text} {
global learn
set words "" ; set check 0
set fx [open $learn(file) r]
while {![eof $fx]} {
set tmp [lindex [gets $fx] 0]
set words "$words $tmp"
if {$tmp != ""} {set check 1}
}
close $fx
if {$check == 0} {putserv "$learn(method) $nick :The learn file is empty"} else {putserv "$learn(method) $nick :Learn words: $words"}
}


proc learn_lockwords {nick host hand chan text} {
global learn
if {[check_access $hand owner] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
set words "" ; set check 0
set fx [open $learn(lockfile) r]
while {![eof $fx]} {
set tmp [gets $fx]
set words "$words $tmp"
if {$tmp != ""} {set check 1}
}
close $fx
if {$check == 0} {putserv "$learn(method) $nick :The lock file is empty"} else {putserv "$learn(method) $nick :Lock words: $words"}
}


proc learn_forceback {nick host hand chan text} {
global learn
if {[check_access $hand owner] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
putlog "#$hand# forced learn backup"
learn_backup
}

proc learn_backup {} {
global learn
set fx1 [open $learn(file) r]
set fx2 [open $learn(backupfile) w]
while {![eof $fx1]} {
set tmp [gets $fx1]
if {$tmp != ""} {puts $fx2 $tmp}
}
putlog "Learn: backup saved to $learn(backupfile)"
timer $learn(backuptime) learn_backup
close $fx1 ; close $fx2
}


proc learn_view {nick host hand chan text} {
global learn
if {[isvalidchan [string tolower $chan]] == 1} {
putserv "$learn(method) $nick :I can't use learn in this channel"
return 0
}
set word [string tolower [lindex $text 0]]
if {$word == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(view) <word>"
return 0
}
if {[check_word $word] == 2} {
putserv "$learn(method) $nick :The word \"$word\" is unknown to me"
return 0
}
set fx [open $learn(file) r]
while {![eof $fx]} {
set tmp [gets $fx]
if {[string compare $word [lindex $tmp 0]] != 0} {continue}
set i 1
set defs [split [lrange $tmp 1 end] "¦"]
set defi ""
while {1} {
set d [lindex $defs [expr $i-1]]
if {$d == ""} {break}
putserv "$learn(method-def) $chan :$word = $d"
incr i 1
}
}
close $fx
}


proc learn_view_msg {nick host hand chan text} {
global learn
if {[isvalidchan $chan] == 1} {
putserv "$learn(method) $nick :I can't use learn in this channel"
return 0
}
set word [string tolower [lindex $text 0]]
if {$word == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(view) <word>"
return 0
}
if {[check_word $word] == 2} {
putserv "$learn(method) $nick :The word \"$word\" is unknown to me"
return 0
}
set fx [open $learn(file) r]
while {![eof $fx]} {
set tmp [gets $fx]
if {[string compare $word [lindex $tmp 0]] != 0} {continue}
set i 1
set defs [split [lrange $tmp 1 end] "¦"]
set defi ""
while {1} {
set d [lindex $defs [expr $i-1]]
if {$d == ""} {break}
putserv "$learn(method-def) $nick :$word = $d"
incr i 1
}
}
close $fx
}


proc learn_del {nick host hand chan text} {
global learn
if {[check_access $hand flags-change] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
set word [string tolower [lindex $text 0]]
set n [lindex $text 1]
if {$n == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(del) <word> <N>"
return 0
}
if {[check_word $word] == 2} {
putserv "$learn(method) $nick :Word not found please use !learn first"
return 0
}
if {[check_lock $word] == 1} {
putserv "$learn(method) $nick :Unable to delete, word is locked"
return 0
}
set fx1 [open $learn(file) r]
set fx2 [open $learn(tempfile) w]
while {![eof $fx1]} {
set tmp [gets $fx1]
set word_check [lindex $tmp 0]
set i 0
set defs [split [lrange $tmp 1 end] "¦"]
set defi ""
while {1} {
if {[expr $i+1] == $n} {incr i 1 ; continue}
set d [lindex $defs $i]
if {$d == ""} {break}
if {$defi == ""} {set defi $d} else {set defi $defi$d}
incr i 1
}
if {$tmp != ""} {
if {[string compare $word $word_check] == 0} {puts $fx2 "$word_check $defi"} else {puts $fx2 $tmp}
}
}
close $fx1 ; close $fx2
exec rm -f $learn(file) ; exec mv $learn(tempfile) $learn(file)
putserv "$learn(method) $nick :Definition \"$n\" deleted from \"$word\" if exists"
}


proc learn_insert {nick host hand chan text} {
global learn
if {[check_access $hand flags-change] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
set word [string tolower [lindex $text 0]]
set definition [lrange $text 1 end]
if {$definition == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(insert) <word> <definition>"
return 0
}
if {[check_word $word] == 2} {
putserv "$learn(method) $nick :Word not found please use !learn first"
return 0
}
if {[check_lock $word] == 1} {
putserv "$learn(method) $nick :Unable to insert, word is locked"
return 0
}
set fx1 [open $learn(file) r]
set fx2 [open $learn(tempfile) w]
while {![eof $fx1]} {
set tmp [gets $fx1]
set word_check [lindex $tmp 0]
if {$tmp != ""} {
if {[string compare $word $word_check] == 0} {puts $fx2 "$tmp$definition "} else {puts $fx2 $tmp}
}
}
close $fx1 ; close $fx2
exec rm -f $learn(file) ; exec mv $learn(tempfile) $learn(file)
putserv "$learn(method) $nick :Definition inserted at the end of word"
}

proc learn_unlock {nick host hand chan text} {
global learn
if {[check_access $hand owner] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
set word [string tolower [lindex $text 0]]
if {$word == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(unlock) <word>"
return 0
}
if {[check_word $word] == 2} {
putserv "$learn(method) $nick :Unable to lock word, word not found"
return 0
}
if {[check_lock $word] == 2} {
putserv "$learn(method) $nick :Unable to unlock, word is not locked"
return 0
}
set fx1 [open $learn(lockfile) r]
set fx2 [open $learn(tempfile) w]
while {![eof $fx1]} {
set tmp [gets $fx1]
set word_check [lindex $tmp 0]
if {[string compare $word $word_check] == 0} {continue} else {puts $fx2 $tmp}
}
close $fx1 ; close $fx2
exec rm -f $learn(lockfile) ; exec mv $learn(tempfile) $learn(lockfile)
putserv "$learn(method) $nick :\"$word\" unlocked"
}


proc learn_lock {nick host hand chan text} {
global learn
if {[check_access $hand owner] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
set word [string tolower [lindex $text 0]]
if {$word == ""} {
putserv "$learn(method) $nick :Invalid syntax, use $learn(lock) <word>"
return 0
}
if {[check_word $word] == 2} {
putserv "$learn(method) $nick :Unable to lock definition, not found"
return 0
}
if {[check_lock $word] == 1} {
putserv "$learn(method) $nick :Definition allready locked"
return 0
}
set fx [open $learn(lockfile) a]
puts $fx $word ; close $fx
putserv "$learn(method) $nick :\"$word\" locked"
}



proc learn_misc {nick host hand chan text} {
global learn
if {[check_access $hand owner] == 2} {
putserv "$learn(method) $nick :You don't have access"
return 0
}
putserv "$learn(method) $nick :\002Dekadent Learn $learn(version) misc information\002"
putserv "$learn(method) $nick :The learn file is: \"$learn(file)\", the backup file is: \"$learn(backupfile)\", the learn temp file is \"$learn(tempfile)\", the learn lock file is \"$learn(lockfile)\", the time between each backup is \"$learn(backuptime)\" minutes, the channels that learn views will not appear is/are \"$learn(non-channels)\"."
putserv "$learn(method) $nick :The flags to learn/forget/insert/delete/list words is/are \"$learn(flags-change)\", the flags to lock/unlock/list locked words/force backup is/are \"$learn(owner)\", the method to response when a nick add/insert/delete/forget.... is \"$learn(method)\" to a nick, the method to response to a view is \"$learn(method-def)\" to a channel."
}
proc learn_help {nick host hand chan text} {
global learn
putserv "$learn(method) $nick :\002*** Dekadent Learn $learn(version) help, the help will be showed if you have the access to that command. ***\002"
putserv "$learn(method) $nick :To view a word do: $learn(view) <word>"
if {[check_access $hand flags-change] == 1} {
putserv "$learn(method) $nick :To add a word do: $learn(add) <word> <definition>"
putserv "$learn(method) $nick :To forget a word do: $learn(forget) <word>"
putserv "$learn(method) $nick :To insert a definition to a word do: $learn(insert) <word> <definition>"
putserv "$learn(method) $nick :To delete a definition from one word do: $learn(del) <word> <N>"
putserv "$learn(method) $nick :To see all definied words do: $learn(wordlist)"
}
if {[check_access $hand owner] == 1} {
putserv "$learn(method) $nick :To lock a word do: $learn(lock) <word>"
putserv "$learn(method) $nick :To unlock a locked word do: $learn(unlock) <word>"
putserv "$learn(method) $nick :To list all locked words do: $learn(lockwords)"
putserv "$learn(method) $nick :To force the learn file to be backuped do: $learn(forcebackup)"
putserv "$learn(method) $nick :If word is locked the word can't be deleted or some definition be inserted to the word"
putserv "$learn(method) $nick :To see some misc information do: $learn(misc)"
}
}

# Happy new 2002 to all dekadents :)
