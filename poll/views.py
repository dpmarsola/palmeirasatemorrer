from django.http import HttpResponse, HttpResponseRedirect
from django.template import loader
from django.shortcuts import render
import datetime
import subprocess
from saopaulotz import SaoPauloTZ

def poll(request):

    if 'unstuck' in request.GET:
        subprocess.run(['./unstuck.sh'])
        return HttpResponseRedirect('/pollthanks')
    else:
        return render(request, "poll.html")

def sendbet(request):

    formItems = request.POST.items()
    x = datetime.datetime.now(SaoPauloTZ())

    prefix=x.strftime("%d%m%Y%H%M%S")
    filename='./tosend/bet_'+prefix+'.msg'

    with open(filename, 'w') as f:
        for item in formItems:
            f.write("%s\n" % str(item))

    return HttpResponseRedirect('/pollthanks')

def pollthanks(request):
    return render(request, 'pollthanks.html')
