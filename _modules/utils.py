import os


def find_file(name, directory='/'):
    for root, dirs, files in os.walk(directory):
        if name in files:
            return os.path.join(root, name)
    raise RuntimeError('could not find {} in {}'
                       .format(name, directory))
