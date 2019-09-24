class Values:
    def __init__(self, value):
        self.value = value
    def getValue(self):
        return self.value
class Record:
    def __init__(self, literal:str, val_dict:dict ):
        self.literal  = literal
        self.val_dict  =  val_dict
    def __eq__(self, other): 
        if( type(other) == Record ):
            if ( self.getLiteral() == other.getLiteral() ):
                if ( self.arity() ==  other.arity()):
                    if( self.getLabels() == other.getLabels() )
                        for key in self.getLabels():
                                if not (self.getVal(key) == other.getVal(key)):
                                    return False
                    else:
                        return False
                else:
                        return False
            else:
                        return False
        else:
            return False
        return False

    def isCompatible( self, other ):
        if type(other) == Record:
            if ( self.getLiteral() == other.getLiteral() ):
                if ( self.arity() ==  other.arity()):
                    return self.getLabels() == other.getLabels() )
                else:
                        return False
            else:
                        return False
        else:
            return False
    
    def arity(self):
        return len(val_dict.keys())

    def getLabels(self):
        return self.val_dict.keys()
    def labelExists(self, label):
        return label in self.val_dict.keys()
        
    def getVal(self, label:str ):
        try:
             self.val_dict[label]
        except:
            return None
    def getLiteral(self ):
        return self.literal
