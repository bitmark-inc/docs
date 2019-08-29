#!/usr/bin/env python3.6
# Copyright (c) 2015-2017 The Bitcoin Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

import hashlib
import sys
import os
from random import SystemRandom
import base64
import hmac

if len(sys.argv) < 2:
    sys.stderr.write('include hostname as an argument to format yaml output\n')
    sys.exit(0)

hostname = sys.argv[1]

def generate(hostname, currency):
    # This uses os.urandom() underneath
    cryptogen = SystemRandom()

    # Create a random username
    rn = [cryptogen.randrange(26) for i in range(24)]
    username = "".join([chr(c + ord('a')) for c in rn])

    #Create 16 byte hex salt
    salt_sequence = [cryptogen.randrange(256) for i in range(16)]
    hexseq = list(map(hex, salt_sequence))
    salt = "".join([x[2:] for x in hexseq])

    # Create 32 byte b64 password
    password = base64.urlsafe_b64encode(os.urandom(32))

    digestmod = hashlib.sha256

    if sys.version_info.major >= 3:
        password = password.decode('utf-8')
        digestmod = 'SHA256'
        pass

    m = hmac.new(bytearray(salt, 'utf-8'), bytearray(password, 'utf-8'), digestmod)
    result = m.hexdigest()

    print('  ' + currency + ':')
    print('    ' + hostname + ':')
    print('      rpcauth:  "' + username + ':' + salt + '$' + result + '"')
    print('      username: "' + username + '"')
    print('      password: "' + password + '"')

generate(hostname, 'btc')
generate(hostname, 'ltc')
