# 04/04/2012
# by doggo #omgwtfnzbs @ EFNET
# drop in and try this script ;) all feedback is welcome

namespace eval imdb  {
namespace eval api {

#time limit between cmds
variable flood_set "10"

#trigger to search by ttid 
variable info_tttrig "-tt"

#title search trigger
variable info_strig "!imdb"

#channel to work in
variable imdb_channel "#toru"


variable ttsearch_url "http://www.omdbapi.com/?i"
variable titlesearch_url "http://www.omdbapi.com/?t"
variable pub "PRIVMSG $imdb::api::imdb_channel"
variable info_htrig "!dontusethi!sever"

}

bind pub -|- $imdb::api::info_tttrig imdb::imdb_evaluate::evaluate_imdb
bind pub -|- $imdb::api::info_strig imdb::imdb_evaluate_search::search_evaluate_imdb
#bind pub -|- $imdb::api::info_htrig imdb::imdb_helper::helper_imdb


# get info from ttid proc
namespace eval imdb_evaluate {
proc evaluate_imdb {nick hand host chan titleid} {

#flood protection, borrowed from http://forum.egghelp.org/viewtopic.php?t=17078 :D

variable imdb_flood

if {[info exists imdb_flood(lasttime,$chan)] && [expr $imdb_flood(lasttime,$chan) + $imdb::api::flood_set] > [clock seconds]} {
   puthelp "$imdb::api::pub :You can use only 1 command in $imdb::api::flood_set seconds. Wait [expr $imdb::api::flood_set - [expr [clock seconds] - $imdb_flood(lasttime,$chan)]] seconds and try again.";return
}

set titleid [stripcodes bcruag $titleid]
set ttid [lindex [split $titleid] 0]
set action ""
set action [lindex [split $titleid] 1]

if {$ttid==""} {putquick "$imdb::api::pub :Usage: $imdb::api::info_ttrig tt1899353";return}
if {![regexp {^tt([0-9]+)$} $ttid match imdbid] } {putquick "$imdb::api::pub :Error: not a valid ttid";return}

catch {set http [::http::geturl $imdb::api::ttsearch_url=tt$imdbid -timeout 15000]} error
set information [::http::data $http]
::http::cleanup $http
regexp -nocase {response\"\:\"(.*?)\"} $information match response

if {![info exists response]} {putquick "$imdb::api::pub :$imdb::api::ttsearch_url=tt$imdbid timed out.. try again in a bit ";return}
if {![string match "True" $response]} {putquick "$imdb::api::pub :Error: Unknown IMDb ID";return}

::imdb::imdb_trigger::trigger_imdb $information $action

set imdb_flood(lasttime,$chan) [clock seconds]
  }
}


# get info from title search proc
namespace eval imdb_evaluate_search {
proc search_evaluate_imdb {nick hand host chan search_text} {

#flood protection, borrowed from http://forum.egghelp.org/viewtopic.php?t=17078 :D

variable imdb_flood

if {[info exists imdb_flood(lasttime,$chan)] && [expr $imdb_flood(lasttime,$chan) + $imdb::api::flood_set] > [clock seconds]} {
   puthelp "$imdb::api::pub :You can use only 1 command in $imdb::api::flood_set seconds. Wait [expr $imdb::api::flood_set - [expr [clock seconds] - $imdb_flood(lasttime,$chan)]] seconds and try again.";return
}

set search_term [stripcodes bcruag $search_text]
set do_search [lrange [split $search_term] 0 end]
set imdbswitch ""

if {$do_search==""} {putquick "$imdb::api::pub :Usage: $imdb::api::info_strig Mission Impossible";return}

if {[regexp -nocase {^([a-z0-9\s]+)\s\-\-([a-z]+)$} $do_search match imdbsearch imdbswitch]} {

catch {set http [::http::geturl $imdb::api::titlesearch_url=[string map { " " "+" } $imdbsearch] -timeout 15000]} error
set information [::http::data $http]
::http::cleanup $http

regexp -nocase {response\"\:\"(.*?)\"} $information match response

if {![info exists response]} {putquick "$imdb::api::pub :Error: $imdb::api::titlesearch_url=[string map { " " "+" } $imdbsearch] timed out.. try again in a bit ";return}
if {![string match "True" $response]} {putquick "$imdb::api::pub :Error: 0 Results for $imdbsearch";return}

::imdb::imdb_trigger::trigger_imdb $information $imdbswitch

} elseif {[regexp {^([a-z0-9\s]+)$} $do_search match imdbsearch]} {

catch {set http [::http::geturl $imdb::api::titlesearch_url=[string map { " " "+" } $imdbsearch] -timeout 15000]} error
set information [::http::data $http]
::http::cleanup $http

regexp -nocase {response\"\:\"(.*?)\"} $information match response

if {![info exists response]} {putquick "$imdb::api::pub :Error: $imdb::api::titlesearch_url=[string map { " " "+" } $imdbsearch] timed out.. try again in a bit ";return}
if {![string match "True" $response]} {putquick "$imdb::api::pub :Error: 0 Results for $imdbsearch";return}

::imdb::imdb_trigger::trigger_imdb $information $imdbswitch

} else {

putquick "$imdb::api::pub :Error: bad input";return

}

set imdb_flood(lasttime,$chan) [clock seconds]
  }
}


# parse the returned jason proc
namespace eval imdb_trigger {
proc trigger_imdb {api_response type} {

set information [lindex $api_response 0]
set action [lindex $type 0]

regexp -nocase {title\"\:\"(.*?)\"} $information match title
regexp -nocase {year\"\:\"(.*?)\"} $information match year
#regexp -nocase {rated\"\:\"(.*?)\"} $information match rated
#regexp -nocase {released\"\:\"(.*?)\"} $information match released
#regexp -nocase {genre\"\:\"(.*?)\"} $information match genre
#regexp -nocase {director\"\:\"(.*?)\"} $information match director
#regexp -nocase {writer\"\:\"(.*?)\"} $information match writer
#regexp -nocase {actors\"\:\"(.*?)\"} $information match actors
#regexp -nocase {plot\"\:\"(.*?)\"} $information match plot
#regexp -nocase {poster\"\:\"(.*?)\"} $information match poster
#regexp -nocase {runtime\"\:\"(.*?)\"} $information match runtime
regexp -nocase {rating\"\:\"(.*?)\"} $information match rating
regexp -nocase {votes\"\:\"(.*?)\"} $information match votes
regexp -nocase {ID\"\:\"(.*?)\"} $information match id

switch -exact -- [string tolower $action] {

"titlesssssss" {
        putquick "$imdb::api::pub :\00308\[IMDB Title\]\017 $title"
}


default {
        putquick "$imdb::api::pub :$title \($year\) - http://www.imdb.com/title/$id/ - $rating/10 \($votes votes\)"
      }
    }
  }
}


# usage helper proc
namespace eval imdb_helper {
proc helper_imdb {nick hand host chan text} {

        putquick "$imdb::api::pub :\00308\[IMDB Search Help\]\017"
        putquick "$imdb::api::pub :\00308\[Search IMDB Id\]\017 $imdb::api::info_tttrig tt0234215 | or | $imdb::api::info_tttrig tt0234215 switch"
        putquick "$imdb::api::pub :\00308\[Search Titles\]\017 $imdb::api::info_strig the matrix reloaded | or | $imdb::api::info_strig the matrix reloaded --switch"
        putquick "$imdb::api::pub :\00308\[Search Switches\]\017 title year rated released genre director writer cast plot poster runtime rating votes link | no switch = spam :D"

  }
}


#//end all
}
