import argparse
import random
import time
import sys

#sys.path.insert(0, './python-osc')

from pythonosc import osc_message_builder
from pythonosc import udp_client

import math
from datetime import datetime, timedelta

def DottedIPToInt( dotted_ip ):
    exp = 3
    intip = 0
    for quad in dotted_ip.split('.'):
        intip = intip + (int(quad) * (256 ** exp))
        exp = exp - 1
    return(intip)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", default="127.0.0.1",
                        help="The ip of the OSC server")
    parser.add_argument("--port", type=int, default=12012,
                        help="The port the OSC server is listening on")
    parser.add_argument("--multiplier", type=float, default=1.0,
                        help="Time multiplier for output")
    parser.add_argument("filename")
    args = parser.parse_args()

    client = udp_client.UDPClient(args.ip, args.port)

    with open(args.filename) as f:
        last = None
        for line in f:
            parts = line.split()
            ip = parts[0]
            timestring = parts[3]+parts[4]
            timestamp = datetime.strptime(timestring.strip('[]'), '%d/%b/%Y:%H:%M:%S%z')
            url = parts[6]
            response = parts[8]
            size = parts[9]
            if last != None:
                sleeptime = timestamp - last
                print(sleeptime)
                print(sleeptime.seconds * args.multiplier)
                #time.sleep(int(sleeptime.seconds * args.multiplier))
                target_time = time.clock() + (sleeptime.seconds * args.multiplier)
                while time.clock() < target_time:
                    pass
            last = timestamp
            try:
                msg = osc_message_builder.OscMessageBuilder(address = "/weblog/ip")
                msg.add_arg(math.sin(DottedIPToInt(ip)), 'f')
                msg = msg.build()
                client.send(msg)
            except:
                pass
            try:
                msg = osc_message_builder.OscMessageBuilder(address = "/weblog/response")
                msg.add_arg(int(response), 'i')
                msg = msg.build()
                client.send(msg)
            except:
                pass
            try:
                msg = osc_message_builder.OscMessageBuilder(address = "/weblog/size")
                msg.add_arg(int(size), 'i')
                msg = msg.build()
                client.send(msg)
            except:
                pass

            try:
                msg = osc_message_builder.OscMessageBuilder(address = "/weblog/url")
                msg.add_arg(url, 's')
                msg = msg.build()
                client.send(msg)
            except:
                pass
