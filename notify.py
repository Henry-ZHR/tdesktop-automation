import asyncio
from os import getenv
from telegram import Bot

bot = Bot(getenv('TELEGRAM_TOKEN'))
asyncio.run(
    bot.send_message(
        getenv('TELEGRAM_TO'),
        f'v{getenv("TDESKTOP_VERSION")} build succeeded\nSummary: {getenv("SUMMARY_URL")}'
    ))
