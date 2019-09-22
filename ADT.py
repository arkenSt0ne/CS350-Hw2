class Record:
    def __init__(self, literal:str, val_dict:dict ):
        self.literal  = literal
        self.val_dict  =  val_dict
    def arity(self):
        return len(val_dict.keys())

    def labelExists(self, label):
        return label in self.val_dict.keys()
        
    def getVal(self, label:str ):
        try:
             self.val_dict[label]
        except:
            return None
    def getLiteral(self ):
        return self.literal
