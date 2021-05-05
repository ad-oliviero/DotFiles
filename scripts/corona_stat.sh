[ "$(stat -c %y ~/.cache/coronav 2>/dev/null | cut -d' ' -f1)" != "$(date '+%Y-%m-%d')" ] && curl -s https://corona-stats.online/italy > ~/.cache/coronav

grep "Italy" ~/.cache/coronav |
	sed "s/\s*//g ; s/║//g ; s/│/;/g" |
	awk -F';' '{print "tc "$3" nc "$4" td "$5" nd "$6}'
