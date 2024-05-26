import asyncio
import os

from telegram import Bot

bot = Bot(os.getenv('TELEGRAM_TOKEN'))
asyncio.run(
    bot.send_message(
        os.getenv('TELEGRAM_TO'),
        f'{os.getenv("VERSION")} build succeeded\nSummary: {os.getenv("SUMMARY_URL")}'
    ))
