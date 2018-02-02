#! /usr/bin/env python3
import json
import sys
from subprocess import Popen, PIPE

if __name__=="__main__":
    addr = sys.argv[1]
    cmd = ["zcash-cli", "z_listreceivedbyaddress", addr]
    p = Popen(cmd, stdout=PIPE)
    output = p.stdout.read()

    transaction_list = json.loads(output)
    for transaction in transaction_list:
        print("transaction id: {}".format(transaction["txid"]))
        print("amount: {}".format(transaction["amount"]))
        try:
            memo = bytearray.fromhex(transaction["memo"]).decode("ascii")
        except UnicodeDecodeError:
            memo = ""
        print("memo: {}\n".format(memo))
