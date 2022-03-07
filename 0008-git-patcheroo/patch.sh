#!/bin/bash

EDITOR_CHOICE=xed

function gitaliases() {
	alias gca='git commit --amend'
	alias gcp='git cherry-pick'
	alias grc='git rebase --continue'
	alias gpf='git push --force'
	alias grh='git reset --hard'
	alias clr='clear'
}

function crej() {
	find . -type f -iname "*.rej" -delete
	find . -type f -iname "*.orig" -delete
}

function orej() {
	find . -type f -iname "*.rej" | while read -r f; do sh -c "$EDITOR_CHOICE $f"; sh -c "$EDITOR_CHOICE ${f/.rej/}"; done
}

function scrape() {
	req=$(curl -s "$1/commits" | grep "Copy the full SHA" | grep -oE "[0-9a-f]{40}")
 	echo -e "$req" > /tmp/req
 	first=$(cat /tmp/req | head -n1)
	if [[ $2 -gt 0 ]]; then
		i=34
		j=$2
		while [ $((j)) -gt 0 ]; do
			link="$1/commits/$3?after=$(echo $first)+$i&branch=$3"
			echo -e "\n$link"
			curl -s "$link" | grep "Copy the full SHA" | grep -oE "[0-9a-f]{40}"
			i=$(($i+35))
			j=$(($j-1))
		done
	fi
	rm /tmp/req
}

function gpatch() {

	# You can export REPO_LINK=https://github.com/torvalds/linux
	# for example and then just call gpatch with the commit SHA
	# instead of the whole link everytime

	link=$(echo "$1" | cut -f1 -d#)
	name=$(echo "$link" | sed "s/.*commit\///g")
	ftmp="/tmp/$name"
#	cmsg="/tmp/$cmsg"
	plog="/tmp/patch_log"

	[[ $REPO_LINK != "" ]] && link="$REPO_LINK/commit/$1"
	curl -s "$link".patch > "$ftmp"
#	curl -s "$link".patch | grep "<title>" | sed 's/<title>//g;s/ · .*//g;s/^[[:space:]]*//g' > "$cmsg"
	cmtmsg=$(cat "$ftmp" | awk '/---/{stop=1} stop==0{print}' | tail -n+2 | sed "s/\[PATCH\]//g")
	newlineys_msg=$(echo "$cmtmsg" | pcregrep -M 'Subject.*\n .*\n')
	if [[ $(echo "$newlineys_msg" | wc -c) -gt 1 ]]; then
		corrected_msg=$(echo "$newlineys_msg" | sed ':a;N;$!ba;s/\n//g')
		echo "Fixing commit msg newlines"
		cmtmsg=$(echo "$cmtmsg" | grep -v "$newlineys_msg")
		cmtmsg=$(echo "$cmtmsg" | sed "/Date:.*/a $corrected_msg")
	fi
	cmtmsg="$2$cmtmsg"
	author="${cmtmsg/From: /}"
	codate="${cmtmsg/Date: /}"
	subjct=$(echo "${cmtmsg/Subject: /}" | tail -n+3)
	subjct=$(echo "$2$subjct" | sed "s/^ //g")
	patch -Np1 < "$ftmp" > "$plog"

 	echo -e "\n\n------------------------------------------------------PATCH DATA START------------------------------------------------------"
 	echo -e "\n$(cat "$plog")\n"
 	echo -e "------------------------------------------------------PATCH DATA END--------------------------------------------------------\n\n"

	result="$(( $(grep -oE "*.rej" "$plog" | wc -c) + $(grep -oE "File to patch:" "$plog" | wc -c) ))"
	if [[ $result -eq 0 ]]; then
		echo -e "\nPatching succeeded. Applying empty commit from original data. Please review the changes and amend it."
		crej
		git ls-files -dmo | grep -v out | while read f; do git add -f "$f"; done
		git commit -m "$subjct" --author="$author" -s # --date="$codate"
		echo -e "\n" && git log --oneline | head -n3
#		rm "$ftmp"
	else
		echo -e "\nPatching failed. Saving the original commit info to \$subjct, author data to \$author, date to \$codate."
 		echo -e "\n\nPlease review the changes and commit it with"
 		echo -e "\n\ngit commit -m \"\$(echo -e  \"\$subjct\")\" --author=\"\$(echo -e  \"\$author\")\" --date=\"\$(echo -e  \"\$codate\")\"."
 		echo -e "\n\nRecent commits:"
		git log --oneline | head -n3
		echo -e "\n"
#		rm "$ftmp"
	fi

}
