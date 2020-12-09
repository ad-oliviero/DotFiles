#install i3lock-color: https://github.com/Raymo111/i3lock-color
# script borrowed from https://github.com/lokesh-krishna/dotfiles
i3lock --nofork                 \
    --ignore-empty-password	\
    --linecolor=00000000        \
    --keyhlcolor=ebcb8b22       \
    --bshlcolor=d8dee922	\
    --separatorcolor=00000000   \
    --radius=0			\
    --indpos="1475:700"		\
    \
    --insidevercolor=00000000	\
    --insidewrongcolor=00000000 \
    --insidecolor=00000000	\
    \
    --ringcolor=e59d1722        \
    --ringvercolor=a3be8c22     \
    --ringwrongcolor=bf616aff   \
    \
    --clock			\
    --timecolor=ebcb8bff	\
    --timestr="%I:%M %p"	\
    --time-font="BatmanForeverAlternate"	\
    --timesize=95		\
    --timepos="1425:900"		\
    --timecolor=ebcb8bff	\
    \
    --datecolor=ebcb8bff	\
    --datestr="%A, %d %B"	\
    --datecolor=ebcb8bff	\
    --date-font="BatmanForeverAlternate"	\
    --datesize=45		\
    --datepos="tx:1025"	\
    \
    --veriftext=""		\
    --wrongtext=""		\
    \
    --indicator			\
    \
    --image=/home/vineeth/Pictures/wallpaper_internet/batman.jpg
