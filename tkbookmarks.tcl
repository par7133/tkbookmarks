#!/usr/local/bin/wish

#package require -exact Tk $tcl_version
package require Tk 8.4

puts ""
puts ""
puts "---------------------------------------"
puts "Released under GPLv3.0"
puts "Copyrights © 2022-2026 Daniele Bonini"
puts "This software is supplied AS-IS, without WARRENTY."
puts "Welcome in TKBOOKMARKS!!"
puts "---------------------------------------"
puts ""
puts ""

cd /home/user/util/tkbin

# Variable and Proc declarations

proc setLabel { idx } {

    global lbltext
    global cmds

    set val "_"
    if {$idx >= 0 && $idx < [array size cmds]} {
      set val $cmds($idx)
      set lbltext $val  
    } else {
      set lbltext ""
    }
    
    if {"[string range $val 0 3]"=="http"} { 
      place .fr.bexec -x 20 -y 237
      place .fr.bclose -x 120 -y 237
    } else {  
      place forget .fr.bexec
      place .fr.bclose -x 20 -y 237
    }
}

proc shutdown {} {
    # perform necessary housework for ensuring that application files
    # are in proper state, lock files are removed, etc.
    
    puts stdout "Good Bye, from TKBOOKMARKS.."
    
    exit
}

# Main Frame
frame .fr
pack .fr -fill both -expand 1

listbox .fr.lb -yscrollcommand { .fr.sb set }
scrollbar .fr.sb -command {.fr.lb yview} -orient vertical

# Reading command list
set fh [open tkbookmarks.ini "r"]

set intli 0
set li 0
while {[gets $fh str] >= 0} {

	set i [string first "=" $str 0]
	set newcmd [string range $str 0 $i-1]
	set newcmdpath [string range $str $i+1 [string length $str]]

  set cmdslbl($intli) $newcmd
	set cmds($intli) $newcmdpath
  
  .fr.lb insert end $cmdslbl($intli)
  
	incr intli
}
close $fh

# DEBUG
#foreach {cmd cmdpath} [array get cmds "0"] {
#  tk_messageBox -message "Command: $cmd Path: $cmdpath" -type ok
#}
#foreach {cmd cmdpath} [array get cmds] {
#  tk_messageBox -message "Command: $cmd Path: $cmdpath" -type ok
#}

# ListBox
bind .fr.lb <<ListboxSelect>> { setLabel [%W curselection]}

#place .fr.lb -x 20 -y 20 
#place .fr.sb -x 180 -y 20

# Label
set lbltext "url to open"

label .fr.lbl -textvariable lbltext
#  .fr.lbl configure -text "exec. cmd"
place .fr.lbl -x 20 -y 200
#pack .fr.lbl.s -side right

# Exec Button
button .fr.bexec -text "Open Url" -command { exec firefox --new-tab $lbltext & }
# pack forget .fr.bexec

# Close Button
button .fr.bclose -text "Exit" -command { shutdown }
place .fr.bclose -x 20 -y 237

# Set frame and controls position
grid .fr.lb .fr.sb -sticky nsew
grid .fr.lb -ipadx 20 -padx 20 -pady 20 -columnspan 2
grid .fr.sb -ipadx 5 -padx 15 -pady 20 
grid columnconfigure .fr 0 -weight 1

# Window
wm title . "Bookmarks"
image create photo imgobj -file tkbookmarks.png
wm iconphoto . imgobj
wm resizable . 0 0
wm attributes . -fullscreen 0
wm geometry . 500x330
wm protocol . WM_DELETE_WINDOW { shutdown }
