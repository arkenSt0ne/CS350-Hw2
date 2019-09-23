import argparse
import json

SAS_id = 0
def get_SAS_id():
    global SAS_id
    SAS_id+=1
    return "s_"+str(SAS_id)

def print_stack(stack):
    print("\nCurr_satck: ")
    for i in stack[::-1]:
        print(i)
    print("")

semantic_stack = []
E = dict() #initial environment

def parse():
    """
    stmt is a list of stmts
    """
    print_stack(semantic_stack)
    if len(semantic_stack)==0:
        return
    (stmt, curr_E) = semantic_stack.pop()
    print("\033[31msingle stmt: ", stmt, curr_E, "\033[0m")
    if type(stmt[0])==list: #means it is a list of statements
        for s in stmt[::-1]: #push in reverse order
            assert(type(s)==list)
            semantic_stack.append((s, curr_E))
    else:
        # print("\033[31msingle stmt: ", stmt, curr_E, "\033[0m")
        splits = stmt[0].split(" ")
        # here comes multiple cases now, like
        if(splits[0]=="var"):
            # expect more stmts
            new_E = curr_E.copy()
            for i in splits[1:]: #all new variables
                if "ident" in i:
                    ident = i[6:-1] #ident(x) -> x
                    new_E[ident] = get_SAS_id();
            for s in stmt[1:][::-1]:
                semantic_stack.append((s, new_E))

        elif (splits[0]=="record"):
            pass
            # expect some feature:ident bindings
        elif (splits[0]=="bind"):
            pass
            # expect only a single stmt
    # else:
        # print("\033[31msingle stmt: ", stmt, "\033[0m")
    parse()


argparser = argparse.ArgumentParser()
argparser.add_argument("-i","--input", help="Input OZ file")
args = argparser.parse_args()
print(args)
input_file = args.input if args.input is not None else "test.oz"

with open(input_file, 'r') as f:
    source = f.read()


stmts = json.loads(source)
# print(stmts)
semantic_stack.append((stmts, E))
parse()
