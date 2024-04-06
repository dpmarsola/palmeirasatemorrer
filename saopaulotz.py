from datetime import tzinfo, timedelta

class SaoPauloTZ(tzinfo):
    def utcoffset(self, dt):
        return timedelta(hours=-3, minutes=0)
    
    def dst(self, dt):
        return timedelta(0)