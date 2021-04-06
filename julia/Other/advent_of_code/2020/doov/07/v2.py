import re

def getContent(content_str):        
    result = {}
    for bag in re.split(", ", content_str):
        match = re.match("([0-9])+ (.*) bags?\\.?\\s?", bag)
        if (match):
            result[match.group(2)] = int(match.group(1))
    return result

def getRules(file_str):
    f = open(file_str, "r")  

    rules = {}
    for line in f.readlines():
        bag_str, content_str = line.split("contain ")
        bag = re.match("(.*) bags?", bag_str, ).group(1)
        rules[bag] = getContent(content_str)
    return rules

def numBags(rules, bag_str):
    leaf_nodes = [val for val in rules.values() if not val]
    print(leaf_nodes)

    if bag_str not in leaf_nodes:
        return sum([rules[bag_str][bag] * (numBags(rules, bag) + 1) for bag in rules[bag_str].keys()])
    else:
        return 0

print(numBags(getRules("input.txt"), "shiny gold"))