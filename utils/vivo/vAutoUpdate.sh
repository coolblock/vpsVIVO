#!/usr/bin/env bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
cd
git clone https://github.com/coolblock/vpsVivo.git 	
cd vpsVivo
git pull
cd

mkdir /root/vivomisc
cd /root/vivomisc
rm -f minver*
rm -f curver*
	echo "starting" >> /root/cronup.txt
wget https://raw.githubusercontent.com/vivocoin/centralstrings/master/minver
/root/mnTroubleshoot/vivo/vivo1_getInfo.sh | grep "\"version"| cut -d: -f2 | cut -d" " -f2 | cut -d"," -f1 > curver

typeset -i currentVersion=$(cat curver)
typeset -i minimumVersion=$(cat minver)

echo "current:$currentVersion" min: "$minimumVersion" >>  /root/cronup.txt
cd
echo " start -- $(date +%T )" >> /root/cronup.txt
if [ "$currentVersion" -lt "$minimumVersion" ] ; then
	echo "needs updating" >> /root/cronup.txt
	echo "needs updating"	
	rm /usr/local/bin/vivod
	if [ -f "/usr/local/bin/vivod" ]; then echo "vivod exists"; else echo "vivod does not exists" ; fi
	/root/vpsVivo/utils/vivo/UpdateAutomaticMnBinMulti.sh
	echo "done updating $( date +%T )" >> /root/cronup.txt
	if [ -f "/usr/local/bin/vivod" ]; then echo "vivod exists"; else echo "vivod does not exists" ; fi
	systemctl daemon-reload

else
	echo "is updated -no change is necessary">> /root/cronup.txt
	echo "is updated -no change is necessary"	
fi

cd

FLOOR=1;
CEILING=24;
RANGE=$(($CEILING-$FLOOR+1));
RESULT=$RANDOM;
let "RESULT %= $RANGE";
RESULT=$(($RESULT+$FLOOR));

	if ! crontab -l | grep "/root/vpsVivo/utils/vivo/vAutoUpdate.sh"; then
		echo "Update check will happen at ($RESULT) hour everyday";
		echo "0 $RESULT * * * /sbin/runuser -l root -c '/root/vpsVivo/utils/vivo/vAutoUpdate.sh'"
		(crontab -l 2>/dev/null; echo "0 $RESULT * * * /sbin/runuser -l root -c '/root/vpsVivo/utils/vivo/vAutoUpdate.sh'") | crontab -
	fi

echo "Ended at  $( date +%T )" >> /root/cronup.txt
echo "Version 2.0" >> /root/cronup.txt
