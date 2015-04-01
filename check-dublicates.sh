#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
cd /var/www/fftr-webhooks/check-dublicates/fftr-peers
if ! git pull > /dev/null 2>&1; then
	exit
fi
TMPFILE=`mktemp /tmp/fftr-peers-dubchecker-XXXXXX`
grep --no-filename "key" * | sort | uniq -d > $TMPFILE

  ### IRC message formatting.  For reference:
  ### \002 bold   \003 color   \017 reset  \026 italic/reverse  \037 underline
  ### 0 white           1 black         2 dark blue         3 dark green
  ### 4 dark red        5 brownish      6 dark purple       7 orange
  ### 8 yellow          9 light green   10 dark teal        11 light teal
  ### 12 light blue     13 light purple 14 dark gray        15 light gray

#  def fmt_url(s)
#    "\00302\037#{s}\017"
#  end
if [ -s "$TMPFILE" ]; then
  echo '/COLOR-RED-ESCAPE/found dublicate keys:/COLOR-RESET-ESCAPE/'
  egrep -o "key \"[0-9a-f]{0,80}" "$TMPFILE" | head -n 3 | while read i; do
    echo -n "$i ("
    grep -F "$i" -l -r . | egrep -o "[-_0-9a-zA-Z]{0,80}" | while read node; do
      echo -n "$node, ";
    done | head -c -2
    echo ")"
  done
else
  echo '/COLOR-GREEN-ESCAPE/found no dublicate keys/COLOR-RESET-ESCAPE/'
fi
#/COLOR-RED-ESCAPE/ \00304\037
#/COLOR-GREEN-ESCAPE/ \00303\037
#/COLOR-RESET-ESCAPE/ \017
rm $TMPFILE
