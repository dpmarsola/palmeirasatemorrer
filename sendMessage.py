import sys
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

def formatMessage(msgDict: dict):
    
    msgText = ''

    msgText += f'*Aposta de:* \n' 
    msgText += f'{msgDict["inputApostador"]} \n'
    msgText += f'\n'
    msgText += f'*Resultado:* \n'
    msgText += f'{msgDict["inputResultadoGeral"]} \n'
    msgText += f'\n'
    msgText += f'*Minuto do Primeiro Gol:* {msgDict["inputMinutoPrimeiroGol"]} \n'
    msgText += f'*Primeiro lance do jogo:* {msgDict["radioPrimeiroLance"]} \n'
    msgText += f'*Primeiro Jogador do Palmeiras a Tomar Cartao:* {msgDict["inputPrimeiroCartao"]} \n'
    msgText += f'\n'
    msgText += f'*Nro. de Impedimentos do Palmeiras:* {msgDict["inputNumeroImpedimentos"]} \n'
    msgText += f'*Nro. de Escanteios do Palmeiras:* {msgDict["inputNumeroImpedimentos"]} \n'
    msgText += f'\n'
    msgText += f'*Teremos Penalti?* {msgDict["radioTeremosPenalti"]} \n'
    msgText += f'*Teremos Gol nos Acrescimos?* {msgDict["radioTeremosGolAcrescimos"]} \n'
    msgText += f'*Teremos Gol de Cabeca?* {msgDict["radioTeremosGolCabeca"]} \n'
    msgText += f'\n'
    msgText += f'_Horario da Aposta: {msgDict["date"]}_ \n'
    msgText += f'_Identificador: {msgDict["aut"]}_ \n'

    print(msgText)
    return msgText

def run():

    # Check if the hour and minute are valid
    # param1: hour
    # param2: minute
    # param3: message file
    try:
        if int(sys.argv[1]) < 0 or int(sys.argv[1]) > 23:
            print('Error: Invalid hour')
            return
        
        if int(sys.argv[2]) < 0 or int(sys.argv[2]) > 59:
            print('Error: Invalid minute')
            return

        if sys.argv[3] == '':
            print('Error: Missing message file')
            return

        hour = int(sys.argv[1])
        minute = int(sys.argv[2])
        fileMessage = sys.argv[3]

    except IndexError:
        print('Error: Incorrect parameters Hour, Minute, Message file')
        return

    try:
        # Read the content of the file
        with open(fileMessage, 'r') as file:
            message = file.read()
    except Exception as e:
        print(f'{e}')
        return

    # Send the message through WhatsApp
    messageReadyToSend = formatMessage(setMessageVariables(message))
    try:
        pywhatkit.sendwhatmsg_to_group("J9c5nVLxz7QJxTrFY3YdOD", messageReadyToSend, hour, minute, 8, True, 5)
    except pywhatkit.core.exceptions.CallTimeException as e:
        pywhatkit.sendwhatmsg_to_group("J9c5nVLxz7QJxTrFY3YdOD", messageReadyToSend, hour+1, minute, 8, True, 5)
        return

if __name__ == '__main__':
    run()
    