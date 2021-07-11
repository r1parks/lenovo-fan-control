# lenovo-fan-control

Is your lenovo laptop blasting the fans at full speed constantly? Get those fans under control with this one weird script! Computer scientists hate him!

## Short Explanation

If you just want this thing to run so you can hear your own thoughts over the sound of your laptop fan, try the following

```shell
sudo ./install.sh
```

If it completes without an error message then congratulations, you're the proud owner of a fan control service. Verify that it is running with

```shell
sudo service lenovo-fan-control status
```

### That didn't work!

Crap. Try this instead

```shell
sudo ./adjust_fan.sh
```

If that doesn't work you're completely out of luck unless you want to debug the scripts yourself. Or I guess you could message me but who knows if I'll respond or if my response will be intelligible. If it does work then you just have to keep that process alive as long as you want your fan controlled. If it dies then so does your computer, probably. Run it in a detached tmux session or something.

## More explanation

This whole thing is just a couple of scripts that can be installed as a systemd service. You can run each script separately to see what they do.

### core_temp.sh

This script should print out the core temp of your computer. It just runs `sensors` and then parses the output with cutting edge text processing tools like `grep`, `sort`, and `tail`. Oh you have `lm-sensors` installed right? Because that's important. I probably should have mentioned that earlier.

### fan_level.py

This script determines what the fan level should be set to based on the temperature provided. Run it like this

```shell
./fan_level.py $TEMP
```

Where $TEMP is some number which will be interpreted as a temperature in celsius. The interesting stuff happens between 35 and 56, anything below that should set the fan to 1 (minimum) and anything above that will set the fan to full-speed (maximum). To run it the way it's used for real:

```shell
./fan_level.py $(./core_temp.sh)
```

If the script fails for any reason it should just output `auto` as a fail safe. Oh and you have python installed right? That's important too. The script should run fine with python 2 if you don't want to install 3, just get rid of the '3' in the shebang.

### adjust_fan.sh

This is the script that the service runs. It just gets the temp from `core_temp.sh`, uses that to get the appropraite fan level from `fan_level.py`, then sets the fan level. It does this on a loop every 10 seconds. That's pretty much it.

### install.sh

This script runs some tests to verify that your system is compatible with the script, creates a service file, then starts the service. If it fails at any point it should give you a useful error message.

### Monitoring

You can control the service using `systemctl` as a normal systemd service. Check the status of the service with

```shell
sudo systemctl status lenovo-fan-control
```

You can also see a live feed of the output of the service with

```shell
journalctl --follow _SYSTEMD_UNIT=lenovo-fan-control.service
```
