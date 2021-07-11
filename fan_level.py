#!/usr/bin/env python3


def get_temp_arg(argv):
    assert len(argv) == 2
    temp = float(argv[1])
    assert 0.0 <= temp < 200.0, "'{}' does not appear to be a valid temperature".format(temp)
    return temp


def get_fan_setting(temp):
    """
    Lowest fan setting is 0, highest is 7
    """
    if temp > 55.0:
        return "full-speed"
    low_temp = 35.0
    high_temp = 50.0
    temp = max(temp, low_temp)
    temp = min(temp, high_temp)
    temp -= low_temp
    temp /= (high_temp - low_temp)
    temp *= 7.0
    return int(temp)


def run_tests():
    assert get_fan_setting(0) == 0
    assert get_fan_setting(20) == 0
    assert get_fan_setting(50) == 7
    assert get_fan_setting(52) == 7
    assert get_fan_setting(56) == 'full-speed'


def main():
    import sys
    run_tests()
    temp = get_temp_arg(sys.argv)
    new_fan_setting = get_fan_setting(temp)
    print(str(new_fan_setting))


def print_temp_settings():
    for temp in range(30, 100, 3):
        print("Temp: {}, Fan Setting: {}".format(temp, get_fan_setting(float(temp))))


if __name__ == '__main__':
    try:
        main()
    except Exception:
        print("auto")
