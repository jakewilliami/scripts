import re

def getContent(content_str):        
    result = {}
    for bag in re.split(", ", content_str):
        match = re.match("([0-9])+ (.*) bags?\\.?\\s?", bag)
        if (match):
            result[match.group(2)] = match.group(1)
    return result

def getRules(file_str):
    f = open(file_str, "r")  

    rules = {}
    for line in f.readlines():
        # bag, content =
        bag_str, content_str = line.split("contain ")
        bag = re.match("(.*) bags?", bag_str, ).group(1)
        rules[bag] = getContent(content_str)
    return rules

def numBags(bag_str):
    rules = getRules("input.txt")

    bags = [key for key in rules.keys() if bag_str in rules[key]]
    added_bags = []
    while True:
        for outer_bag in rules.keys():
            for bag in bags:
                if bag in rules[outer_bag].keys():
                    if outer_bag in (bags + added_bags):
                        continue
                    added_bags.append(outer_bag)
        if len(added_bags) == 0:
            break
        else:
            for added_bag in added_bags:
                bags.append(added_bag)
            added_bags = []
    return bags


print(len(numBags("shiny gold")))