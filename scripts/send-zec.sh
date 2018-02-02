#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

echo
echo "Let's send a shielded ${bold}Zcash${normal} transaction!"
echo
# Todo: Output balances too and only those addresses with balances
echo "Here are your shielded addresses:"
echo
zcash-cli z_listaddresses | jq -r "to_entries|map(\"\(.value|tostring)\")|.[]"
echo
# Todo: Data validation
read -p 'From: ' zfrom
read -p 'To: ' zto
read -p 'Amount: ' zamount
read -p 'Fee: ' zfee
read -p 'Memo: ' zmemo
echo
echo "Sending..."
zhexmemo=$(echo $zmemo | xxd -p -c 512)
echo
if [[ $(zcash-cli z_sendmany "$zfrom" "[{\"amount\": $zamount, \"address\": \"$zto\", \"memo\": \"$zhexmemo\"}]" 1 $zfee) = *opid* ]]; then
	echo "Success! Now check its status after a couple minutes with ${bold}zcash-cli z_getoperationresult${normal}."
else
	echo
	echo "Uh oh. Something went wrong. Check your settings and balance and try again."
fi
echo
# Todo: Instead, run z_getoperationresult at intervals until a result is returned, then parse.
