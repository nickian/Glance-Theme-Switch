# How to use this script

This script is a hack for [Glance](https://github.com/glanceapp/glance) that allows you to automatically switch between a dark and a light theme based on time. It will append the contents of the `dark.yml` or `light.yml` file (which contents a theme definition) when the hour matches those defined in `.env`. It will also restart your Glance docker container.

1. Rename the `.env.example` file to `.env` and set your configuration values in this file.

2. Remove the theme information from your current `glance.yml` file and add the contents of either `dark.yml` or `light.yml` from this repository to the very bottom of the `glance.yml` file (You can find [more themes here](https://github.com/glanceapp/glance/blob/main/docs/themes.md)).

3. Make sure the script is executable: 

```
chmod +x /path/to/Glance-Theme-Switcher/theme_switch.sh
```

3. Add a rule to cron to run this script every hour `crontab -e`:

```
0 * * * * bash /path/to/Glance-Theme-Switcher/theme_switch.sh
```

Make sure the user running the cron job has permissions to read/write the files and restart your docker container.