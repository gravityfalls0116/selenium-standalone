#!/bin/bash

print_selenium_env () {
    CHROME_VERSION=$(/home/node/node_modules/selenium-standalone/.selenium/chromedriver/latest-x64/chromedriver --version)
    FIREFOX_VERSION=$(/home/node/node_modules/selenium-standalone/.selenium/geckodriver/latest-x64/geckodriver --version)

    SS_CONFIG=$(npm root -g)/selenium-standalone/lib/default-config.js
    SELENIUM_SERVER=$(node -p -e "require('$SS_CONFIG').version")
    CHROME_WD_VERSION=$(node -p -e "require('$SS_CONFIG').drivers.chrome.version")
    FIREFOX_WD_VERSION=$(node -p -e "require('$SS_CONFIG').drivers.firefox.version")

    echo ""
    echo ""
    echo "Selenium environment:"
    echo ""
    echo "  * Browsers:"
    echo "    - ${CHROME_VERSION}"
    echo "    - ${FIREFOX_VERSION}"
    echo ""
    echo "  * Selenium:"
    echo "    - Server:            ${SELENIUM_SERVER}"
    echo "    - Chrome webdriver:  ${CHROME_WD_VERSION}"
    echo "    - Firefox webdriver: ${FIREFOX_WD_VERSION}"
    echo ""
    echo ""
}
