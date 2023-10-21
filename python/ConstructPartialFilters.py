from typing import Callable, Iterable, Any, Iterator
import itertools
import random


def _partial_filters(n: int, char_set: Iterable[str], f: Callable[[str], Iterable[Any]]) -> (bool, str):
    raise NotImplementedError


def partial_filters(char_set: Iterable[str], f: Callable[[str], Iterable[Any]], n: int = 1, c2: str = '') -> Iterator[str]:
    for c in char_set:
        r = f(c + c2 + '*')
        if len(r) > 10:
            yield from partial_filters(char_set, f, n=n+ 1, c2=c + c2)
        else:
            yield c


# Examples

def ord_range(a: str, b: str): return range(ord(a), ord(b) + 1)
hex_itr = (chr(c) for c in itertools.chain(ord_range('a', 'b'), ord_range('0', '9')))
rand_f = lambda self: random.choices(range(1), k=random.randint(0, 20))
filters = partial_filters(hex_itr, rand_f)
for f in filters:
    print(f)
