import pywhatkit
import sys

def sendMessageWhatsapp(message, hour, minute, groupID):
    
    try:
        pywhatkit.sendwhatmsg_to_group(groupID, message, int(hour), int(minute), 8, True, 5)
        #pywhatkit.sendwhatmsg_to_group("LsifEHTcGUjIIed4NMoPTh", messageReadyToSendWhatsapp, hour+1, minute, 8, True, 5)
    except pywhatkit.core.exceptions.CallTimeException as e:
        pywhatkit.sendwhatmsg_to_group(groupID, message, int(hour), int(minute), 8, True, 5)
        #pywhatkit.sendwhatmsg_to_group("LsifEHTcGUjIIed4NMoPTh", messageReadyToSendWhatsapp, hour+1, minute, 8, True, 5)
        return

sendMessageWhatsapp(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
