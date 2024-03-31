from django.http import HttpResponse, HttpResponseRedirect
from django.template import loader
from django.shortcuts import render
import datetime

def index(request):
    # template = loader.get_template('index.html')
    return render(request, "index.html")
    # return HttpResponse(template.render({},request))

def sendbet(request):

    formItems = request.POST.items()
    x = datetime.datetime.now()

    prefix=x.strftime("%d%m%Y%H%M%S")
    filename='./tosend/bet_'+prefix+'.msg'

    with open(filename, 'w') as f:
        for item in formItems:
            f.write("%s\n" % str(item))

    return HttpResponseRedirect('/poll')
