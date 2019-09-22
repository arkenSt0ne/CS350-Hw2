class E:
    def __init__():
        self.ds = dict()
    def isBound( self, var_name ):
        return var_name in self.ds.keys()
    def adjunct( self, var_name, binding):
        try:
            self.ds[var_name] = binding
            return 0
        except :
            return -1

## add more operations on Environment!!