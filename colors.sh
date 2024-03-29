#
# Mostly ANSI/XTerm supported colours. Some of these may not work on all
# terminals but for most modern Linux or MacOS terminals these will work
# just fine. Most of these could probably be computed using tput and in
# theory work on any terminal but frankly I am too lazy to do that and
# have just hard-coded the common SGR escape sequences. These work for
# my purposes. Your mileage may vary.
#
csi=$'\e['
sgr='m'

black_fg="${dotps1_beg}${csi}30${sgr}${dotps1_end}"
bold_black_fg="${dotps1_beg}${csi}90${sgr}${dotps1_end}"
black_bg="${dotps1_beg}${csi}40${sgr}${dotps1_end}"
bold_black_bg="${dotps1_beg}${csi}100${sgr}${dotps1_end}"
red_fg="${dotps1_beg}${csi}31${sgr}${dotps1_end}"
bold_red_fg="${dotps1_beg}${csi}91${sgr}${dotps1_end}"
red_bg="${dotps1_beg}${csi}41${sgr}${dotps1_end}"
bold_red_bg="${dotps1_beg}${csi}101${sgr}${dotps1_end}"
green_fg="${dotps1_beg}${csi}32${sgr}${dotps1_end}"
bold_green_fg="${dotps1_beg}${csi}92${sgr}${dotps1_end}"
green_bg="${dotps1_beg}${csi}42${sgr}${dotps1_end}"
bold_green_bg="${dotps1_beg}${csi}102${sgr}${dotps1_end}"
yellow_fg="${dotps1_beg}${csi}33${sgr}${dotps1_end}"
bold_yellow_fg="${dotps1_beg}${csi}93${sgr}${dotps1_end}"
yellow_bg="${dotps1_beg}${csi}43${sgr}${dotps1_end}"
bold_yellow_bg="${dotps1_beg}${csi}103${sgr}${dotps1_end}"
blue_fg="${dotps1_beg}${csi}34${sgr}${dotps1_end}"
bold_blue_fg="${dotps1_beg}${csi}94${sgr}${dotps1_end}"
blue_bg="${dotps1_beg}${csi}44${sgr}${dotps1_end}"
bold_blue_bg="${dotps1_beg}${csi}104${sgr}${dotps1_end}"
magenta_fg="${dotps1_beg}${csi}35${sgr}${dotps1_end}"
bold_magenta_fg="${dotps1_beg}${csi}95${sgr}${dotps1_end}"
magenta_bg="${dotps1_beg}${csi}45${sgr}${dotps1_end}"
bold_magenta_bg="${dotps1_beg}${csi}105${sgr}${dotps1_end}"
cyan_fg="${dotps1_beg}${csi}36${sgr}${dotps1_end}"
bold_cyan_fg="${dotps1_beg}${csi}96${sgr}${dotps1_end}"
cyan_bg="${dotps1_beg}${csi}46${sgr}${dotps1_end}"
bold_cyan_bg="${dotps1_beg}${csi}106${sgr}${dotps1_end}"
white_fg="${dotps1_beg}${csi}37${sgr}${dotps1_end}"
bold_white_fg="${dotps1_beg}${csi}97${sgr}${dotps1_end}"
white_bg="${dotps1_beg}${csi}47${sgr}${dotps1_end}"
bold_white_bg="${dotps1_beg}${csi}107${sgr}${dotps1_end}"
normal_fg="${dotps1_beg}${csi}39${sgr}${dotps1_end}"
normal_bg="${dotps1_beg}${csi}49${sgr}${dotps1_end}"
bold="${dotps1_beg}${csi}1${sgr}${dotps1_end}"
no_bold="${dotps1_beg}${csi}22${sgr}${dotps1_end}"
italic="${dotps1_beg}${csi}3${sgr}${dotps1_end}"
no_italic="${dotps1_beg}${csi}23${sgr}${dotps1_end}"
ul="${dotps1_beg}${csi}4${sgr}${dotps1_end}"
no_ul="${dotps1_beg}${csi}24${sgr}${dotps1_end}"
ol="${dotps1_beg}${csi}53${sgr}${dotps1_end}"
no_ol="${dotps1_beg}${csi}55${sgr}${dotps1_end}"
blink="${dotps1_beg}${csi}5${sgr}${dotps1_end}"
no_blink="${dotps1_beg}${csi}25${sgr}${dotps1_end}"
rev="${dotps1_beg}${csi}7${sgr}${dotps1_end}"
no_rev="${dotps1_beg}${csi}27${sgr}${dotps1_end}"
normal="${dotps1_beg}${csi}0${sgr}${dotps1_end}"

#
# Special characters that appear to work on almost all UTF-8 aware terminals.
# Use at your own risk.
#
bullet='•'
square='▪'
emdash='–'
para='§'
currency='¤'
yen='¥'
leftchev='«'
rightchev='»'
plusminus='±'
degree='°'
divide='÷'
tlcorner='┌'
blcorner='└'
trcorner='┐'
brcorner='┘'
horiz='─'
vert='│'
mljoin='├'
mrjoin='┤'
bothjoin='┼'
lright='╱'
lleft='╲'
lboth='╳'
openset='⟃'
closeset='⟄'
diamond='⟡'
dleft='⟢'
dright='⟣'
ddot='⟐'
check='✓'
heavycheck='✔'
cross='✕'
heavycross='✖'
dingcross='✗'
ballotcross='✘'
heavyplus='✚'
latincross='✝'
maltese='✠'
david='✡'
scissors='✂'
envelope='✉'
heart='❤'
rightarrow='➜'
brokenarrow='⇢'
arrowhead='➤'
uparrow='↑'
downarrow='↓'
detached='⌿'
circle='○'
