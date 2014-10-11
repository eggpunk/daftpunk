###; Serie Info by Zio
###; TCL port by Harm
###; Usage: !ep <series title>
###; Example: !ep secret agent man

###; Greets: Zio, B0unty

###; Path to curl binary
set si(curl) "/usr/bin/curl"

bind pub - !ep epguidelookup

proc epguidelookup {nick uhost hand chan args} {
	global si
	set args [string trim [string trim $args \{ ] \}]
	set arglist [llength [split $args]]
	if { $arglist < 1 } {putserv "PRIVMSG $chan :Please input a search criteria."; return 0}
	###; clean args
	set shortout 1
	if {[string match -nocase "-l" [lindex $args 0]]} {set shortout 0; set args [lrange $args 1 end]}
	if {[string match -nocase "the" [lindex $args 0]]} {set args [lrange $args 1 end]}
	set searchstring ""; set searchstringtxt ""; set tryurl ""
	foreach arg $args {
		set searchstring "$searchstring+%22$arg%22"
		set searchstringtxt "$searchstringtxt $arg"
		set tryurl "$tryurl$arg"
	}
	###; initial search
	set tryurl [string map {. {} - {} _ {} , {} : {}} $tryurl]
	set shownameurl "http://epguides.com/$tryurl/"
	catch {exec $si(curl) -s -A "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" $shownameurl} html
	###; not found ? perform search
	if {[string match "*The page cannot be found*" $html]} {
		unset html
		set searchurl "http://epguides.master.com/texis/master/search/?q=$searchstring"
		catch {exec $si(curl) -s -A "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" $searchurl} html
		###; get url
		if {[regexp {<b>URL:</b> <FONT SIZE=-1>[^<]+} $html title]} {
			set pos [expr [string last > $title] + 1]; set shownameurl [string range $title $pos end-1]
		}
	}
	###; dump page
	unset html
	catch {exec $si(curl) -s -A "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" "$shownameurl"} html
	if {[string match "*The page cannot be found*" $html]} {putserv "PRIVMSG $chan :No show found."; return 0}
	set title "N/A"; set episodenumber "N/A"; set season "N/A"
	set seasonepisode "N/A"; set airdate "N/A"; set currentdate "N/A"
	set episodename "N/A"; set lastep [list N/A N/A N/A N/A]; set nextep [list N/A N/A N/A N/A]
	set epday "N/A"; set epmonth "N/A"; set epyear "N/A"
	set nowday "N/A"; set nowmonth "N/A"; set nowyear "N/A"
	###; get title
	set foundtitle 0
	if {[regexp {<title>[^(]+} $html title]} {
		set pos [expr [string last > $title] + 1]
		set title [string range $title $pos end-1]
		set title [string map {\r {} \n {}} $title]
		set foundtitle 1
	}
	###; Get current day, month and year
	set nowday [string trimleft [clock format [clock seconds] -format "%d"] 0]
	set nowmonth [string trimleft [clock format [clock seconds] -format "%m"] 0]
	set nowyear [clock format [clock seconds] -format "%Y"]
	###; Extract schedule information, if found
	set foundlastep 0; set foundnextep 0; set episodenumber 0
	if {![string match "*\n*" $html]} {set lines [split $html <br>]} else {set lines [split $html \n]}
	foreach line $lines {
		if {[string match "*-*" $line]} {
			set lbit [regexp -inline -- {[0-9]+.*([0-9]+)- ?([0-9]+).* ([0-9]+/[A-Za-z]+/[0-9]+) *(.*) *} $line]
			if {[llength $lbit]==0} {
				set lbit [regexp -inline -- {[0-9]+.*([0-9]+)- ?([0-9]+) *(.*) *} $line]
				if {[llength $lbit]!=0 && ![string equal "N/A" [lindex $lastep 0]] && [string equal "N/A" [lindex $nextep 0]]} {
					incr episodenumber 1
					set nextep [list "$episodenumber" "[lindex $lbit 1]x[lindex $lbit 2]" "N/A" "[lindex $lbit 3]"]
					break
				}
			} else {
				incr episodenumber 1
				set season [lindex $lbit 1]; set seasonepisode [lindex $lbit 2]
				set airdate [lindex $lbit 3]; set episodename [lindex $lbit 4]
			}
		} else {
			if {![string match "*.*-*" $line]} {continue}
			set lbit [regexp -inline -- {([0-9]+).*([0-9]+)- ?([0-9]+).* ([0-9]+/[A-Za-z]+/[0-9]+) *(.*) *} $line]
			if {[llength $lbit]==0} {
				set lbit [regexp -inline -- {([0-9]+).*([0-9]+)- ?([0-9]+) *(.*) *} $line]
				if {[llength $lbit]!=0 && ![string equal "N/A" [lindex $lastep 0]] && [string equal "N/A" [lindex $nextep 0]]} {
					incr episodenumber 1
					set cleanep [regexp -inline -- {.*>(.*)</a>} [lindex $lbit 4]]
					set nextep [list "$episodenumber" "[lindex $lbit 2]x[lindex $lbit 3]" "N/A" "[lindex $cleanep 1]"]
					break
				}
			} else {
				incr episodenumber 1
				set season [lindex $lbit 2]; set seasonepisode [lindex $lbit 3]
				set airdate [lindex $lbit 4]; set episodename [lindex $lbit 5]
				set cleanep [regexp -inline -- {.*>(.*)</a>} $episodename]
				if {[llength $cleanep]==0} {continue} else {set episodename [lindex $cleanep 1]}
			}
		}
		set epday [lindex $airdate 0]; set epmonth [lindex $airdate 1]; set epyear [string trimleft [lindex $airdate 2] 0]
		set epmonth [string map {Jan 1 Feb 2 Mar 3 Apr 4 May 5 Jun 6 Jul 7 Aug 8 Sep 9 Oct 10 Nov 11 Dec 12} $epmonth]
		if {$epyear < 50 && $epyear >= 0} {set epyear [expr $epyear + 2000]}
		if {$epyear >= 50 && $epyear <= 99} {set epyear [expr $epyear + 1900]}
		if {$epyear < $nowyear && $epyear!=0} {
			set foundlastep 1; set foundnextep 0; set nextep [list -]
			set lastep [list "$season\x$seasonepisode" "[lindex $epday] [lindex $airdate 1] [lindex $epyear]"]
		} elseif {$epyear == $nowyear && $epyear!=0} {
			if {$epmonth < $nowmonth && $epmonth!=0} {
				set foundlastep 1; set foundnextep 0; set nextep [list -]
				set lastep [list "$season\x$seasonepisode" "[lindex $epday] [lindex $airdate 1] [lindex $epyear]"]
			} elseif {$epmonth == $nowmonth && $epmonth!=0} {
				if {$epday <= $nowday && $epday!=0} {
					set foundlastep 1; set foundnextep 0; set nextep [list -]
					set lastep [list "$season\x$seasonepisode" "[lindex $epday] [lindex $airdate 1] [lindex $epyear]"]
				}
			}
		}
		if {!$foundnextep} {
			if {$epyear > $nowyear} { 
				set epyear [expr $epyear + 0] 
				set foundnextep 1
				set nextep [list "$season\x$seasonepisode" "[lindex $epday] [lindex $airdate 1] [lindex $epyear]"]
			} elseif {$epyear == $nowyear || $epyear==0} {
				if {$epmonth > $nowmonth} {
					set foundnextep 1
					set nextep [list "$season\x$seasonepisode" "[lindex $epday] [lindex $airdate 1] [lindex $epyear]"]
				} elseif {$epmonth == $nowmonth} {
					if {$epday > $nowday} {
						set foundnextep 1
						set nextep [list "$season\x$seasonepisode" "[lindex $epday] [lindex $airdate 1] [lindex $epyear]"]
					}
				}
			}
		}
	}

	if {$shortout} {
		puthelp "PRIVMSG $chan :$title - Last: [lindex $lastep ] Next: [lindex $nextep ]"
	} else {
		if {$foundtitle} {
			puthelp "PRIVMSG $chan :Title: $title"
		} else {
			puthelp "PRIVMSG $chan :Title: No title found"
		}
		if {$foundlastep} {
			puthelp "PRIVMSG $chan :Latest Ep: [join $lastep " :: "]"
		} else {
			puthelp "PRIVMSG $chan :Latest Ep: No episode found"
		}
		if {$foundnextep} {
			puthelp "PRIVMSG $chan :Next Ep: [join $nextep " :: "]"
		} else {
			puthelp "PRIVMSG $chan :Next Ep: No episode found"
		}
	}
	return 0
}

putlog "\002Loaded\002: Ep-Guide Series Lookup Script (c) Zio 2004 (tcl mod by Harm)"
return
