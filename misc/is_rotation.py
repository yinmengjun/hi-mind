def is_rotation(s1, s2):
    if s1 is None or s2 is None:
        return False
    if len(s1) != len(s2):
        return False
    if s1 == s2:
        return False

    def is_substring(s3, s4):
        return s3 in s4

    return is_substring(s1, s2 + s2)


print(is_rotation('rotationstring', 'stringrotation'))  # True
print(is_rotation('rotationstring', 'rotationstring'))  # False
