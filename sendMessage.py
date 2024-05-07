import asyncio
import datetime
from email.header import Header
from email.mime.text import MIMEText
import sys
import smtplib
import time
import pywhatkit

import pywhatkit

def setMessageVariables(message):

    result = message.split('\n')
    res = []
    msgDict = {}
    for a in result:
        res.append(a.replace('\'', '').replace('(', '').replace(')', '').replace(',', ''))
                
    for b in res:
        try:
            c = b.split(' ')
            i=0
            value=''

            while i < len(c):
                if ( i == 0):
                    key = c[i]
                else:
                    if (i == 1):
                        value = value + c[i]
                    else:
                        value = value + ' ' + c[i]
                i += 1

            msgDict[key] = value
        except IndexError:
            continue

    return msgDict

def formatMessageWhatsapp(msgDict: dict):
    
    msgText = ''

    msgText += f'=============== \n' 
    msgText += f'*Aposta de:* \n' 
    msgText += f'{msgDict["inputApostador"]} \n'
    msgText += f'\n'
    msgText += f'*Resultado:* \n'
    msgText += f'{msgDict["inputResultadoGeral"]} \n'
    msgText += f'\n'
    msgText += f'*Primeiro Jogador do Palmeiras a Fazer Gol:* {msgDict["inputPrimeiroJogadorGol"]} \n'
    msgText += f'*Minuto do Primeiro Gol:* {msgDict["inputMinutoPrimeiroGol"]} \n'
    msgText += f'*Primeiro Jogador do Palmeiras a Tomar Cartao:* {msgDict["inputPrimeiroCartao"]} \n'
    msgText += f'*Primeiro lance do jogo:* {msgDict["radioPrimeiroLance"]} \n'
    msgText += f'\n'
    msgText += f'*Teremos Penalti?* {msgDict["radioTeremosPenalti"]} \n'
    msgText += f'*Teremos Gol nos Acrescimos?* {msgDict["radioTeremosGolAcrescimos"]} \n'
    msgText += f'*Teremos Gol de Cabeca?* {msgDict["radioTeremosGolCabeca"]} \n'
    msgText += f'\n'
    msgText += f'*Nro. de Escanteios do Palmeiras:* {msgDict["inputNumeroEscanteios"]} \n'
    msgText += f'*Nro. de Impedimentos do Palmeiras:* {msgDict["inputNumeroImpedimentos"]} \n'
    msgText += f'\n'
    msgText += f'_Horario da Aposta: {msgDict["date"]}_ \n'
    msgText += f'_Identificador: {msgDict["aut"]}_ \n'

    print(msgText)
    return msgText

def formatMessageEmail(msgDict: dict):
    
    msgText = ''

    msgText += f'Aposta de: \n' 
    msgText += f'{msgDict["inputApostador"]} \n'
    msgText += f'\n'
    msgText += f'Resultado: \n'
    msgText += f'{msgDict["inputResultadoGeral"]} \n'
    msgText += f'\n'
    msgText += f'Primeiro Jogador do Palmeiras a Fazer Gol: {msgDict["inputPrimeiroJogadorGol"]} \n'
    msgText += f'Minuto do Primeiro Gol: {msgDict["inputMinutoPrimeiroGol"]} \n'
    msgText += f'Primeiro Jogador do Palmeiras a Tomar Cartao: {msgDict["inputPrimeiroCartao"]} \n'
    msgText += f'Primeiro lance do jogo: {msgDict["radioPrimeiroLance"]} \n'
    msgText += f'\n'
    msgText += f'Teremos Penalti? {msgDict["radioTeremosPenalti"]} \n'
    msgText += f'Teremos Gol nos Acrescimos? {msgDict["radioTeremosGolAcrescimos"]} \n'
    msgText += f'Teremos Gol de Cabeca? {msgDict["radioTeremosGolCabeca"]} \n'
    msgText += f'\n'
    msgText += f'Nro. de Escanteios do Palmeiras: {msgDict["inputNumeroEscanteios"]} \n'
    msgText += f'Nro. de Impedimentos do Palmeiras: {msgDict["inputNumeroImpedimentos"]} \n'
    msgText += f'\n'
    msgText += f'Horario da Aposta: {msgDict["date"]} \n'
    msgText += f'Identificador: {msgDict["aut"]} \n'

    print(msgText)
    return msgText

def performInputValidations():

    # Check if the hour and minute are valid
    # param1: hour
    # param2: minute
    # param3: message file
    try:
        if int(sys.argv[1]) < 0 or int(sys.argv[1]) > 23:
            print(f'{datetime.datetime.now()} - Error: Invalid hour')
            return
        
        if int(sys.argv[2]) < 0 or int(sys.argv[2]) > 59:
            print(f'{datetime.datetime.now()} - Error: Invalid minute')
            return

        if sys.argv[3] == '':
            print(f'{datetime.datetime.now()} - Error: Missing message file')
            return

    except IndexError:
        print(f'{datetime.datetime.now()} - Error: Incorrect parameters Hour, Minute, Message file')
        return


def readParmsFromFile(msgDict: dict):

    parmDict = {}

    # Read the content of the file
    if msgDict["flagTest"] == 'True':
        filename = './cfg/parms.cfg@test'
    else:
        filename = './cfg/parms.cfg'

    with open(filename, 'r') as file:
        parms=file.read()

    try:
        for line in parms.split('\n'):
            parmDict[line.split('=')[0]] = line.split('=')[1]
    except IndexError:
        pass

    return parmDict
            

def readMessageFromFile():

    fileMessage = sys.argv[3]

    try:
        # Read the content of the file
        with open(fileMessage, 'r') as file:
            message = file.read()
    except Exception as e:
        print(f'{e}')

    return message


def sendMessageEmail(message):

    # Send the message through Email
    messageReadyToSendEmail = formatMessageEmail(setMessageVariables(message))

    try:
        # send via email
        server = smtplib.SMTP('smtp-relay.brevo.com', 587)

        with open('./security/credentials', 'r') as file:
            credentials = file.read().split('\n')
            username = credentials[0]
            password = credentials[1]

        recipients = parms['to_email'].split(',')

        msg = MIMEText(messageReadyToSendEmail, 'plain', 'utf-8')
        msg['Subject'] = Header(f'{parms["subject"]}', 'utf-8')
        msg['From'] = parms['from_email']
        msg['To'] = ", ".join(recipients)

        server.ehlo()
        server.starttls()
        server.login(username,password)
        server.send_message(msg)
        server.quit()

        print(f'{datetime.datetime.now()} - Email sent successfully to {msg["To"]}')

    except Exception as e:
        print(f'{datetime.datetime.now()} - An error occured while sending email: {e}')
        return
    

async def sendMessageWhatsappAsync(message):

    # Send the message through WhatsApp
    messageReadyToSendWhatsapp = formatMessageWhatsapp(setMessageVariables(message))
    
    try:

        hour = int(sys.argv[1])
        minute = int(sys.argv[2])

        async with asyncio.timeout(100):
            await asyncio.create_subprocess_exec('python3', 'pywhatkitWrapper.py', messageReadyToSendWhatsapp, str(hour), str(minute), parms['groupID'], stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE)
    except asyncio.TimeoutError:
        print(f'{datetime.datetime.now()} - Timeout occurred while sending message through WhatsApp. Closing the process')
        return

def sendMessageWhatsapp(message):

    # Send the message through WhatsApp
    messageReadyToSendWhatsapp = formatMessageWhatsapp(setMessageVariables(message))
    
    # Send the message through WhatsApp
    messageReadyToSend = formatMessageWhatsapp(setMessageVariables(message))
    try:

        hour = int(sys.argv[1])
        minute = int(sys.argv[2])
    
        pywhatkit.sendwhatmsg_to_group(parms['groupID'], messageReadyToSend, hour, minute, int(parms['seconds_to_wait_until_send']), True, int(parms['seconds_to_wait_for_close']))
        #pywhatkit.sendwhatmsg_to_group("LsifEHTcGUjIIed4NMoPTh", messageReadyToSend, hour, minute, 8, True, 5)
    except pywhatkit.core.exceptions.CallTimeException as e:
        pywhatkit.sendwhatmsg_to_group(parms['groupID'], messageReadyToSend, hour, minute+1, int(parms['seconds_to_wait_until_send']), True, int(parms['seconds_to_wait_for_close']))
        #pywhatkit.sendwhatmsg_to_group("LsifEHTcGUjIIed4NMoPTh", messageReadyToSend, hour+1, minute, 8, True, 5)
        return

if __name__ == '__main__':
    performInputValidations()
    message = readMessageFromFile()
    parms=readParmsFromFile(setMessageVariables(message))
    sendMessageEmail(message)
    sendMessageWhatsapp(message)
    #asyncio.run(sendMessageWhatsappAsync(message))    
