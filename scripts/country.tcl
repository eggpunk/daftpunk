set ccver "v1.2"
# country code script 1.2 for eggdrop v1.3
# edited by toot <toot@melnet.co.uk>
# tested on eggdrop v1.3.28+
# i got the original code from entertain.tcl which probably ripped
# it from somewhere else before ;)

bind dcc - country dcc_country
bind msg - country msg_country
bind pub - !country pub_country

proc dcc_country {hand idx arg} {
  global country symbol made_up
  if {$arg == "" || [llength $arg] > 1} {
    putdcc $idx "Correct usage: .country <node>"
    putdcc $idx "      Example: .country .[lindex $symbol [rand [llength $country]]]"
    return 0
  }
  set this [lsearch -exact $symbol [string trimleft [string toupper $arg] .]]
  if {$this > -1} {
    putdcc $idx "Country name for .[string trimleft [string toupper $arg] .] is [lindex $country $this]"
    return 0
  } else {
    make_up
    putdcc $idx "Country name for .[string trimleft [string toupper $arg] .] is $made_up :P"
    return 0
  }
}

proc msg_country {nick uhost hand arg} {
  global country symbol botnick made_up
  if {$arg == "" || [llength $arg] > 1} {
    putserv "NOTICE $nick :Correct usage: /msg $botnick country <node>"
    putserv "NOTICE $nick :      Example: /msg botnick country .[lindex $symbol [rand [llength $country]]]"
    return 0
  }
  set this [lsearch -exact $symbol [string trimleft [string toupper $arg] .]]
  if {$this > -1} {
    putserv "NOTICE $nick :Country name for .[string trimleft [string toupper $arg] .] is [lindex $country $this]"
    return 1
  } else {
    make_up
    putserv "NOTICE $nick :Country name for .[string trimleft [string toupper $arg] .] is $made_up :P"
    return 0
  }
}

proc pub_country {nick uhost hand channel arg} {
  global country symbol botnick made_up
  if {$arg == "" || [llength $arg] > 1} {
    putserv "NOTICE $nick :Correct usage: !country <node>"
    putserv "NOTICE $nick :      Example: !country .[lindex $symbol [rand [llength $country]]]"
    return 0
  }
  set this [lsearch -exact $symbol [string trimleft [string toupper $arg] .]]
  if {$this > -1} {
    putserv "PRIVMSG $channel :Country name for .[string trimleft [string toupper $arg] .] is [lindex $country $this]"
    return 1
  } else {
    make_up
    putserv "PRIVMSG $channel :Country name for .[string trimleft [string toupper $arg] .] is $made_up :P"
    return 0
  }
}

set country {
 "South Georgia and the South Sandwich Islands" "Ascension Island"
"Afghanistan"
 "Albania" "Algeria" "American Samoa"
 "Andorra" "Angola" "Anguilla" "Antarctica"
 "Antigua And Barbuda" "Argentina" "Armenia" "Aruba"
 "Australia" "Austria" "Azerbaijan" "Bahamas"
 "Bahrain" "Bangladesh" "Barbados" "Belarus"
 "Belgium" "Belize" "Benin" "Bermuda"
 "Bhutan" "Bolivia" "Bosnia" "Botswana"
 "Bouvet Island" "Brazil" "British Indian Ocean Territory" "Brunei Darussalam"
"Bulgaria" "Burkina Faso" "Burundi" "Byelorussian SSR"
 "Cambodia" "Cameroon" "Canada" "Cap Verde"
 "Cayman Islands" "Central African Republic" "Chad" "Chile"
 "China" "Christmas Island" "Cocos (Keeling) Islands" "Colombia"
 "Comoros" "Congo" "Cook Islands" "Costa Rica"
 "Cote D'ivoire" "Croatia" "Hrvatska" "Cuba"
 "Cyprus" "Czechoslovakia" "Denmark" "Djibouti"
 "Dominica" "Dominican Republic" "East Timor" "Ecuador"
 "Egypt" "El Salvador" "Equatorial Guinea" "Estonia"
 "Ethiopia" "Falkland Islands" "Malvinas" "Faroe Islands"
 "Fiji" "Finland" "France" "French Guiana"
 "French Polynesia" "French Southern Territories" "Gabon" "Gambia"
 "Georgia" "Germany" "Deutschland" "Ghana"
 "Gibraltar" "Greece" "Greenland" "Grenada"
 "Guadeloupe" "Guam" "Guatemala" "Guinea"
 "Guinea Bissau" "Gyana" "Haiti" "Heard And Mc Donald Islands"
 "Honduras" "Hong Kong" "Hungary" "Iceland"
 "India" "Indonesia" "Iran" "Iraq"
 "Ireland" "Israel" "Italy" "Jamaica"
 "Japan" "Jordan" "Kazakhstan" "Kenya"
 "Kiribati" "North Korea" "South Korea" "Kuwait"
 "Kyrgyzstan" "Laos" "Latvia" "Lebanon"
 "Lesotho" "Liberia" "Libyan Arab Jamahiriya" "Liechtenstein"
 "Lithuania" "Luxembourg" "Macau" "Macedonia"
 "Madagascar" "Malawi" "Malaysia" "Maldives"
 "Mali" "Malta" "Marshall Islands" "Martinique"
 "Mauritania" "Mauritius" "Mexico" "Micronesia"
 "Moldova" "Monaco" "Mongolia" "Montserrat"
 "Morocco" "Mozambique" "Myanmar" "Namibia"
 "Nauru" "Nepal" "Netherlands" "Netherlands Antilles"
 "Neutral Zone" "New Caledonia" "New Zealand" "Nicaragua"
 "Niger" "Nigeria" "Niue" "Norfolk Island"
 "Northern Mariana Islands" "Norway" "Oman" "Pakistan"
 "Palau" "Panama" "Papua New Guinea" "Paraguay"
 "Peru" "Philippines" "Pitcairn" "Poland"
 "Portugal" "Puerto Rico" "Qatar" "Reunion"
 "Romania" "Russian Federation" "Rwanda" "Saint Kitts And Nevis"
 "Saint Lucia" "Saint Vincent and the Grenadines" "Samoa" "San Marino"
 "Sao Tome And Principe" "Saudi Arabia" "Senegal" "Seychelles"
 "Sierra Leone" "Singapore" "Slovenia" "Solomon Islands"
 "Somalia" "South Africa" "Spain" "Sri Lanka"
 "St. Helena" "St. Pierre and Miquelon" "Sudan" "Suriname"
 "Svalbard And Jan Mayen Islands" "Swaziland" "Sweden" "Switzerland"
 "Cantons Of Helvetia" "Syrian Arab Republic" "Taiwan" "Tajikistan"
 "Tanzania" "Thailand" "Togo" "Tokelau"
 "Tonga" "Trinidad and Tobago" "Tunisia" "Turkey"
 "Turkmenistan" "Turks and Caicos Islands" "Tuvalu" "Uganda"
"Ukrainian SSR" "United Arab Emirates" "United Kingdom" "Great Britain"
 "United States of America" "United States Minor Outlying Islands" "Uruguay" "Soviet Union"
 "Uzbekistan" "Vanuatu" "Vatican City State" "Venezuela"
 "Viet Nam" "Virgin Islands (US)" "Virgin Islands (UK)" "Wallis and Futuna Islands"
 "Western Sahara" "Yemen" "Yugoslavia" "Zaire"
 "Zambia" "Zimbabwe" "Commercial Organisation (US)" "Educational Institution (Us)"
 "Networking Organisation (US)" "Military (US)" "Non-Profit Organisation (Us)" "Government (Us)"
 "Korea - Democratic People's Republic Of" "Korea - Republic Of" "Lao Peoples' Democratic Republic" "Russia"
 "Slovakia" "Czech"
}

set symbol {
 GS AC AF AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE
 BZ BJ BM BT BO BA BW BV BR IO BN BG BF BI BY KH CM CA CV KY CF
 TD CL CN CX CC CO KM CG CK CR CI HR HR CU CY CS DK DJ DM DO TP
 EC EG SV GQ EE ET FK FK FO FJ FI FR GF PF TF GA GM GE DE DE GH
 GI GR GL GD GP GU GT GN GW GY HT HM HN HK HU IS IN ID IR IQ IE
 IL IT JM JP JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU
 MO MK MG MW MY MV ML MT MH MQ MR MU MX FM MD MC MN MS MA MZ MM
 NA NR NP NL AN NT NC NZ NI NE NG NU NF MP NO OM PK PW PA PG PY
 PE PH PN PL PT PR QA RE RO RU RW KN LC VC WS SM ST SA SN SC SL
 SG SI SB SO ZA ES LK SH PM SD SR SJ SZ SE CH CH SY TW TJ TZ TH
 TG TK TO TT TN TR TM TC TV UG UA AE UK GB US UM UY SU UZ VU VA
 VE VN VI VG WF EH YE YU ZR ZM ZW COM EDU NET MIL ORG GOV KP KR
 LA SU SK CZ
}

set country1 { 
Pineapple Peperonni Cucummber Happy Adventure Stupid Idiot
Wallpaper Porno 
} 

set country2 {
Land Island Islands State Heaven Hell Beach
}

proc make_up {} {
global made_up country1 country2
set made_up "[lindex $country1 [rand [llength $country1]]] [lindex $country2 [rand [llength $country2]]]"
}

putlog "\002country codes\002 $ccver edited by toot, loaded!@"
