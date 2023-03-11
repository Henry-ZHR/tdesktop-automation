from os import getenv
from telegram import Bot

bot = Bot(getenv('TELEGRAM_TOKEN'))
bot.send_message(getenv('TELEGRAM_TO'),
                 f'v{getenv("TDESKTOP_VERSION")} build succeeded')
