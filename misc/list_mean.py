def list_mean(lst):
    lst.sort()
    lst2 = lst[1:-1]
    return round((sum(lst2) / len(lst2)), 1)
