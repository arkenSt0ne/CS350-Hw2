from  ADT import *
from E import E
class SAS:

    def __init__(self):
        self.__new_var_count__ = 0
        self.__sas__M = dict() # Data Structure is not defined!. QUICK-UNION-FIND can be used.
        self.__sas__S = dict() # Length of the structure

    def __isValue(self, obj):
        return type(obj) == Record or type(obj) == Values 

    def __findRoot(self, tempVar): # Assuming that tempVar is in the  SAS
        parent = self.__sas__M[tempVar]
        while parent != self.__sas__M[parent]:
            parent = self.__sas__M[parent]
        return parent

    def __getType( self, tempVar):
        # to be filled!
        return 'somethting'

    def get_new_tmp(self):
        t = self.__new_var_count__ 
        self.__new_var_count__ += 1 
        return '$var#'+str(t)

    def Bind(self, tempVar1, tempVar2, mode):

        if self.__isValue(tempVar1) and self.__isValue(tempVar2):
            #special case
            return -1
        # at least on Variable
        if self.__isValue(tempVar1) or self.__isValue(tempVar2):
            # one variable and value
            # assume var has variable and val has value
            if 
            if self.

    def isBounded(self, tempVar):
        '''
            tempVar: can either be a value or binding
            if tempVar -> Value then False
            else check in the SAS to find the binding of the tempVar
        '''
        # check if the tempVar is a value
        if self.__isValue( tempVar ):
            return False
        parent = self.__findRoot(tempVar)
        return self.__isValue(parent)

    def Unify(self, tempVar1, tempVar2 ):
        c1 = self.isBounded(tempVar1)
        c2 = self.isBounded(tempVar2)
        if not (c1 or  c2 ): # Both variables unbounded!
            #TODO: mark them UNIFIED
            self.Bind( tempVar1, tempVar2, mode = 2)
        elif c1 ^ c2 : # Any one of them is bounded
            self.Bind( tempVar1, tempVar2, mode = 1)
            #TODO:Mark the variable unified.
        else:
            # Both of them bounded
            type1 = self.__getType( tempVar1 )
            type2 = self.__getType( tempVar2 )
            if type1 == type2:
                val1 = self.__findRoot( tempVar1 )
                val2 = self.__findRoot( tempVar2 )
                if type1 == Record:
                    #TODO: do something
                    if val1.isCompatible( val2 ) :
                        for key in 

                else:
                    # check if the parents are having the same value
                    if val1 == val2:
                        return 1
                    else:
                        raise ValueError(' Unification of two different values not allowed! ')
            else:
                raise TypeError(' Unification of incompatible types not allowed')

