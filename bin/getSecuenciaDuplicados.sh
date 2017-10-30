#!/bin/sh

if [ -e "$EJECUTABLES/.dups_$1" ]; then
	SEQUENCEDUP="$(head -n1 "$EJECUTABLES/.dups_$1")"
	echo "$SEQUENCEDUP + 1" | bc > "$EJECUTABLES/.dups_$1"
else
	SEQUENCEDUP=0
	echo "1" > "$EJECUTABLES/.dups_$1"
fi

return $SEQUENCEDUP