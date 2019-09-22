from  ADT import *
class SAS:
    def __init__(self):
        self.__new_var_count__ = 0
        self.__sas__M = dict() # Data Structure is not defined!. QUICK-UNION-FIND can be used.
        self.__sas__S = dict() # Length of the structure
    def get_new_tmp(self):
        t = self.__new_var_count__ 
        self.__new_var_count__ += 1 
        return '$var#'+str(t)
    def __isValue(self, obj):
        return type(obj) == Record or type(obj) == Values 
    def __findRoot(self, tempVar): # Assuming that tempVar is in the  SAS
        parent = self.__sas__M[tempVar]
        while parent != self.__sas__M[parent]:
            parent = self.__sas__M[parent]
        return parent
    def Merge(self, tempVar1, tempVar2):

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
        parent = self.__findRoot(tempVar)
        return self.__isValue(parent)
