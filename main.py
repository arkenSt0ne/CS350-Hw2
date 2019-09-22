import argparse

argparser = argparse.ArgumentParser()
argparser.add_argument("-i","--input", help="Input OZ file")
args = argparser.parse_args()
print(args)
input_file = args.input if args.input is not None else "test.oz"

with open(input_file, 'r') as f:
    text_code = f.read()
print(test_code)