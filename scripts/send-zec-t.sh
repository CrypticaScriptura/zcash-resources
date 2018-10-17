#!/bin/bash

set -e

bold=$(tput bold)
normal=$(tput sgr0)

echo
echo "Let's send a shielded ${bold}Zcash${normal} transaction!"
echo
echo "Here are your shielded addresses and balances:"
echo
paste <(zcash-cli z_listaddresses |  jq -r "to_entries|map(\"\(.value|tostring)\")|.[]") <(zcash-cli z_listaddresses |  jq -r "to_entries|map(\"\(.value|tostring)\")|.[]" | xargs -n1 zcash-cli z_getbalance) | column -s $'\t' -t
echo
echo Now to construct your transaction.
echo
# Todo: Data validation
read -p 'From: ' zfrom
read -p 'To: ' zto
read -p 'Amount: ' zamount
read -p 'Fee: ' zfee
echo
echo "Sending..."
echo
if [[ $(zcash-cli z_sendmany "$zfrom" "[{\"amount\": $zamount, \"address\": \"$zto\"}]" 1 $zfee) = *opid* ]]; then
	echo "Success! Verify the status after a couple minutes with ${bold}zcash-cli z_getoperationresult${normal}."
else
	echo
	echo "Uh oh. Something went wrong. Check your settings and balance and try again."
fi
echo
