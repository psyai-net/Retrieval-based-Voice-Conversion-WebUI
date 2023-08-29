import time
import logging

logging.getLogger("numba").setLevel(logging.WARN)

default_tag = "RVC-Fn-Time"


def timer_decorator(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        logging.warning(f"{default_tag}-{func.__name__} : {end_time - start_time} sec")
        return result

    return wrapper
